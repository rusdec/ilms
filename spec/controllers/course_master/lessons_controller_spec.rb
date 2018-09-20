require_relative '../controller_helper'

RSpec.describe CourseMaster::LessonsController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:course_master) }
    let(:course) { create(:course, author: user) }
    let(:lessons) { create_list(:lesson, 3, course: course, author: course.author) }
    let(:params) { { course_id: course } }

    before do
      lessons[2].parent = lessons[0]
      lessons[1].parent = lessons[2]
    end

    context 'when author' do
      before do
        sign_in(user)
        get :index, params: params
      end

      it 'assigns Course to @course' do
        expect(assigns(:course)).to eq(course)
      end

      it 'assigns Lessons of course to @lessons' do
        expect(assigns(:lessons)).to eq(course.lessons.roots_and_descendants_preordered)
      end

      it 'decorates assigned @lessons' do
        expect(assigns(:lessons)).to be_decorated
      end
    end # context 'when author'

    context 'when not author' do
      before do
        sign_in(create(:course_master))
        get :index, params: params
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end # context 'when not author'
  end

  describe 'GET #edit' do
    let(:user) { create(:course_master) }
    let!(:lesson) { create(:course, :with_lesson, author: user).lessons.last }
    let(:params) { { id: lesson } }

    context 'when author' do
      before do
        sign_in(user)
        get :edit, params: params
      end

      it 'assigns Lesson to @lesson' do
        expect(assigns(:lesson)).to eq(lesson)
      end

      it 'decorates assigned @lesson' do
        expect(assigns(:lesson)).to be_decorated
      end

      it 'assigns course persisted Lessons to @lessons' do
        expect(assigns(:lessons)).to eq(lesson.course.lessons.persisted)
      end
    end

    context 'when not author' do
      before do
        sign_in(create(:course_master))
        get :edit, params: params
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end # context 'when author'

  describe 'GET #new' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, author: user) }
    let(:params) { { course_id: course } }

    context 'Any manage role' do
      context 'Author of course' do
        before do
          sign_in(user)
          get :new, params: params
        end

        it 'assigns Lesson to @lesson' do
          expect(assigns(:lesson)).to be_a_new(Lesson)
        end

        it 'decorates assigned @lesson' do
          expect(assigns(:lesson)).to be_decorated
        end

        it 'relates @lesson with course' do
          expect(assigns(:lesson).course).to eq(course)
        end

        it 'assigns course Lessons to @lessons' do
          expect(assigns(:lessons)).to eq(course.lessons.persisted)
        end

        it 'assigns Course to @course' do
          expect(assigns(:course)).to eq(course)
        end


      end

      context 'Not author of course' do
        before { sign_in(create(:course_master)) }

        it 'redirect to root' do
          get :new, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end # context 'Any manage role'

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :new, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'Any user with any manager role' do
      let(:user) { create(:course_master) }
      let(:course) { create(:course, author: user) }

      context 'when author of course' do
        before { sign_in(user) }

        context 'with invalid data' do
          let(:params) do
            { course_id: course,
              lesson: attributes_for(:invalid_lesson),
              format: :json }
          end

          context 'when json' do
            it 'can\'t create lesson' do
              expect{
                post :create, params: params
              }.to_not change(user.lessons, :count)
            end

            it 'return error object' do
              post :create, params: params
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end # context 'with invalid data'

        context 'with valid data' do
          let(:params) do
            { course_id: course, lesson: attributes_for(:lesson), format: :json }
          end

          context 'when json' do
            it 'can create lesson related with author' do
              expect{
                post :create, params: params
              }.to change(user.lessons, :count).by(1)
            end

            it 'created lesson related with parent course' do
              expect{
                post :create, params: params
              }.to change(course.lessons, :count).by(1)
            end

            it 'return success object' do
              post :create, params: params
              expect(response).to match_json_schema('lessons/create/success')
            end
          end # context 'when json'
        end # context 'with valid data'
      end

      context 'when not author of course' do
        let(:params) do
          { course_id: course, lesson: attributes_for(:lesson), format: :json }
        end
        before { sign_in(create(:course_master)) }

        context 'when json' do
          it 'return error object' do
            post :create, params: params
            expect(response).to match_json_schema('shared/errors')
          end

          it 'can\'t create lesson' do
            expect{
              post :create, params: params
            }.to_not change(course.lessons, :count)
          end
        end
      end # context 'when not author of course'
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:course_master) }
    let!(:lesson) { create(:course, :with_lesson, author: user).lessons.last }
    let(:params) { { id: lesson, format: :json } }
    
    context 'when author of lesson' do
      before { sign_in(user) }

      context 'when json' do
        it 'can delete lesson' do
          expect{
            delete :destroy, params: params
          }.to change(lesson.course.lessons, :count).by(-1)
        end

        it 'return success object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('lessons/destroy/success')
        end
      end
    end # context 'when author of lesson'

    context 'when not author of lesson' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        it 'can\'t delete lesson' do
          expect{
            delete :destroy, params: params
          }.to_not change(lesson.course.lessons, :count)
        end

        it 'return error object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end # context 'when not author of lesson'
  end

  describe 'PATCH #update' do
    context 'Any user with manager role' do
      let!(:course) { create(:course, :with_lessons) }
      let(:lesson) { course.lessons.last }
      let(:parent_lesson) { course.lessons.first }
      let!(:old_title) { lesson.title }

      context 'when author' do
        before { sign_in(lesson.author) }

        context 'with valid data' do
          let(:params) do
            { id: lesson, lesson: { title: 'NewLessonTitle',
                                    parent_id: parent_lesson},
                                    format: :json }
          end

          context 'when json' do
            before { patch :update, params: params }

            it 'can update lesson' do
              lesson.reload
              expect(lesson.title).to eq('NewLessonTitle')
            end

            it 'return success object' do
              expect(response).to match_json_schema('lessons/update/success')
            end
          end
        end # context 'with valid data'

        context 'with invalid data' do
          let(:params) { { id: lesson, lesson: { title: nil }, format: :json } }

          context 'when json' do
            before { patch :update, params: params }

            it 'can\'t update lesson' do
              lesson.reload
              expect(lesson.title).to eq(old_title)
            end

            it 'return error object' do
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end # context 'with invalid data'
      end # context 'when author'

      context 'when not author' do
        before { sign_in(create(:course_master)) }
        let(:params) do
          { id: lesson, lesson: { title: 'NewLessonTitle' }, format: :json }
        end

        context 'when json' do
          before { patch :update, params: params }

          it 'can\'t update lesson' do
            lesson.reload
            expect(lesson.title).to eq(old_title)
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when not author'
    end # context 'Any user with manager role'
  end
end
