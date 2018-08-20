require_relative '../controller_helper'

RSpec.describe CourseMaster::CoursesController, type: :controller do

  describe 'GET #show' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, author: user) }
    let(:params) { { id: course } }

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :show, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'Any manage role' do
      before do
        sign_in(user)
        get :show, params: params
      end

      it 'Course assigns to @course' do
        expect(assigns(:course).object).to eq(course)
      end

      it '@course should be decorated' do
        expect(assigns(:course)).to be_decorated
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, author: user) }
    let(:params) { { id: course.id } }

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :edit, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'Any manage role' do
      before do
        sign_in(user)
        get :edit, params: params
      end

      it 'Course assigns to @course' do
        expect(assigns(:course)).to eq(course)
      end

      it '@course is decorated' do
        expect(assigns(:course)).to be_decorated
      end
    end
  end

  describe 'GET #new' do
    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :new
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'Any manage role' do
      let(:user) { create(:course_master) }

      before do
        sign_in(user)
        get :new
      end

      it 'New Course assigns to @course' do
        expect(assigns(:course)).to be_a_new(Course)
      end

      it '@course is decorated' do
        expect(assigns(:course)).to be_decorated
      end

      it 'New Course related with his author' do
        expect(user).to be_author_of(assigns(:course))
      end
    end # context 'Any manage role'
  end

  describe 'GET #index' do
    context 'when CourseMaster' do
      let!(:user) { create(:course_master) }

      before do
        [user, create(:course_master)].each do |user|
          create_list(:course, 5, author: user)
        end
        sign_in(user)
        get :index
      end
      
      it 'all user Cource assign to @cources' do
        expect(assigns(:courses)).to eq(user.courses)
      end

      it 'render index' do
        expect(response).to render_template(:index)
      end
    end # context 'when CourseMaster'

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :index
          expect(response).to redirect_to(root_path)
        end
      end
    end # non_manage_roles.each do |role|
  end

  describe 'POST #create' do

    context 'when non manage role' do
      let(:params) { { course: attributes_for(:course), format: :json } }

      non_manage_roles.each do |role|
        context "when #{role}" do
          before { sign_in(create(role.underscore.to_sym)) }
          
          context 'when json' do
            it 'can\'t create course' do
              expect{
                post :create, params: params
              }.to_not change(Course, :count)
            end

            it 'return error object' do
              post :create, params: params
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end # context "when #{role}"
      end # non_manage_roles.each do |role|
    end # context 'when non manage role'

    context 'Any manage role' do
      let(:user) { create(:course_master) }
      before { sign_in(user) }

      context 'when valid data' do
        let(:params) do
          { course: attributes_for(:course), format: :json }
        end

        context 'when json' do
          it 'can create course related with user' do
            expect {
              post :create, params: params
            }.to change(user.courses, :count).by(1)
          end

          it 'return course object' do
            post :create, params: params
            expect(response).to match_json_schema('courses/create/success')
          end
        end
      end # context 'when valid data'

      context 'when invalid data' do
        let(:invalid_params) do
          { course: attributes_for(:invalid_course), format: :json }
        end

        context 'when json' do
          it 'can\'t create course' do
            expect {
              post :create, params: invalid_params
            }.to_not change(user.courses, :count)
          end

          it 'return error' do
            post :create, params: invalid_params
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when invalid data'
    end # context 'Any manage role'
  end

  describe 'PATCH #update' do
    let(:user) { create(:course_master) }
    let(:course) { create(:course, author: user) }

    context 'when author' do
      before { sign_in(user) }

      context 'when valid data' do
        let!(:params) do
          { course: { title: 'NewValidTitle' }, id: course, format: :json }
        end

        context 'when json' do
          before { patch :update, params: params }

          it 'can update course' do
            course.reload
            expect(course.title).to eq(params[:course][:title])
          end

          it 'return course object' do
            expect(response).to match_json_schema('courses/update/success')
          end
        end
      end # context 'when valid data'

      context 'when invalid data' do
        let(:invalid_params) do
          { course: { title: nil }, id: course.id, format: :json }
        end

        context 'when json' do
          let!(:old_title) { course.title }
          before { patch :update, params: invalid_params }

          it 'can\'t update own course' do
            course.reload
            expect(course.title).to eq(old_title)
          end

          it 'return errors' do
            expect(response).to match_json_schema('shared/errors')
          end
        end # context 'when json'
      end # context 'when invalid data'
    end # context 'when author'

    context 'when not author' do
      before { sign_in(create(:course_master)) }
      let(:params) do
        { course: { title: 'NewValidTitle' }, id: course.id, format: :json }
      end
      let!(:old_title) { course.title }

      context 'when json' do
        before { patch :update, params: params }

        it 'can\'t update course' do
          course.reload
          expect(course.title).to eq(old_title)
        end

        it 'return error object' do
          expect(response).to match_json_schema('shared/errors')
        end
      end # context 'when json'
    end # context 'when not author'
  end
  

  describe 'DELETE #destroy' do
    let(:course) { create(:course_master, :with_course).courses.last }
    let(:params) { { id: course.id, format: :json } }

    context 'when author' do
      before { sign_in(course.author) }

      context 'when json' do
        it 'can destroy course' do
          expect{
            delete :destroy, params: params
          }.to change(course.author.courses, :count).by(-1)
        end

        it 'return course object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('courses/destroy/success')
        end
      end # context 'when json'
    end # context 'when author'

    context 'Not author' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        it 'can\'t delete course' do
          expect{
            delete :destroy, params: params
          }.to_not change(course.author.courses, :count)
        end

        it 'return errors' do
          delete :destroy, params: params
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end # context 'Not author'
  end
end
