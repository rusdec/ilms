require_relative '../controller_helper'

RSpec.describe CourseMaster::LessonsController, type: :controller do

  describe 'GET #index' do
    let(:course_master) { create(:course_master) }
    let(:course) { create(:course, user_id: course_master.id) }
    let(:params) { { course_id: course.id } }

    before do
      [course, create(:course, user_id: course_master.id)].each do |course|
        create_list(:lesson, 5, user_id: course_master.id, course: course)
      end
    end

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :index, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Lessons of the course assign to @lessons' do
          get :index, params: params
          expect(assigns(:lessons)).to eq(course.lessons)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:course_master) }
    let(:course) { create(:course, user_id: create(:course_master).id) }
    let!(:lesson) { create(:lesson, user_id: user.id, course_id: course.id) }
    let(:params) { { course_id: course.id, id: lesson.id } }

    context "Any manage role" do
      before { sign_in(user) }

      it 'Lesson assigns to @lesson' do
        get :show, params: params
        expect(assigns(:lesson)).to eq(lesson)
      end
    end
  end

  describe 'GET #new' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, user_id: user.id) }
    let(:params) { { course_id: course.id } }

    context 'Any manage role' do
      context 'Author of course' do
        before { sign_in(user) }

        it 'New Lesson assigns to @lesson' do
          get :new, params: params
          expect(assigns(:lesson)).to be_a_new(Lesson)
        end

        it 'New Lesson releated with his author' do
          get :new, params: params
          expect(user).to be_author_of(assigns(:lesson))
        end
      end

      context 'Not author of course' do
        before { sign_in(create(:course_master)) }

        it 'redirect to root' do
          get :new, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

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
      let(:course) { create(:course, user_id: user.id) }

      context 'when author of course' do
        before { sign_in(user) }

        context 'with invalid data' do
          let(:params) do
            { course_id: course.id,
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

          context 'when html' do
            before { params.delete(:format) }

            it 'can\'t create lesson' do
              expect{
                post :create, params: params
              }.to_not change(user.lessons, :count)
            end

            it 'redirect to root' do
              post :create, params: params
              expect(response).to redirect_to(root_path)
            end
          end
        end

        context 'with valid data' do
          let(:params) do
            { course_id: course.id, lesson: attributes_for(:lesson), format: :json }
          end

          context 'when html' do
            before { params.delete(:format) }

            it 'can\'t create lesson' do
              expect{
                post :create, params: params
              }.to_not change(user.lessons, :count)
            end

            it 'redirect to root' do
              post :create, params: params
              expect(response).to redirect_to(root_path)
            end
          end

          context 'when json' do
            it 'can create lesson' do
              expect{
                post :create, params: params
              }.to change(user.lessons, :count).by(1)
            end

            it 'created lesson related with his course' do
              expect{
                post :create, params: params
              }.to change(course.lessons, :count).by(1)
            end

            it 'return success object' do
              post :create, params: params
              expect(response).to match_json_schema('lessons/create/success')
            end
          end
        end
      end

      context 'when not author of course' do
        let(:params) do
          { course_id: course.id, lesson: attributes_for(:lesson), format: :json }
        end
        before { sign_in(create(:course_master)) }

        context 'when html' do
          before { params.delete(:format) }

          it 'redirect to root' do
            post :create, params: params
            expect(response).to redirect_to(root_path)
          end

          it 'can\'t create lesson' do
            expect{
              post :create, params: params
            }.to_not change(course.lessons, :count)
          end
        end

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
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:course_master) }
    let(:course) { create(:course, user_id: user.id) }
    let!(:lesson) { create(:lesson, course_id: course.id, user_id: user.id) }
    let(:params) { { id: lesson.id, format: :json } }
    
    context 'when author of lesson' do
      before { sign_in(user) }

      context 'when html' do
        before { params.delete(:format) }

        it 'can\'t delete lesson' do
          expect{
            delete :destroy, params: params
          }.to_not change(course.lessons, :count)
        end

        it 'redirect to root' do
          delete :destroy, params: params
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when json' do
        it 'can delete lesson' do
          expect{
            delete :destroy, params: params
          }.to change(course.lessons, :count).by(-1)
        end

        it 'return success object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('lessons/destroy/success')
        end
      end
    end

    context 'when not author of lesson' do
      before { sign_in(create(:course_master)) }

      context 'when html' do
        before { params.delete(:format) }

        it 'can\'t delete lesson' do
          expect{
            delete :destroy, params: params
          }.to_not change(course.lessons, :count)
        end

        it 'redirect to root' do
          delete :destroy, params: params
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when json' do
        it 'can\'t delete lesson' do
          expect{
            delete :destroy, params: params
          }.to_not change(course.lessons, :count)
        end

        it 'return error object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end
  end
end
