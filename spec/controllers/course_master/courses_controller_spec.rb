require_relative '../controller_helper'

RSpec.describe CourseMaster::CoursesController, type: :controller do

  describe 'GET #edit' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, user_id: user.id) }
    let(:params) do
      { id: course.id }
    end

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
      before { sign_in(user) }

      it 'Course assigns to @course' do
        get :edit, params: params
        expect(assigns(:course)).to eq(course)
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
    end
  end

  describe 'GET #index' do
    manage_roles.each do |role|
      context "#{role}" do
        before do
          create_list(:course, 5, user_id: create(:administrator).id)
          sign_in(create(role.underscore.to_sym))
          get :index
        end

        it 'Cource assign to @cources' do
          expect(assigns(:courses)).to eq(Course.all)
        end

        it 'render index' do
          expect(response).to render_template(:index)
        end
      end
    end

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :index
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:course_params) { attributes_for(:course) }

    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          post :create, params: { course: course_params }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    manage_roles.each do |role|
      context "#{role}" do
        let(:user) { create(role.underscore.to_sym) }
        before { sign_in(user) }

        it 'can create course with valid data' do
          post :create, params: { course: course_params }
          expect(Course.last.title).to eq(course_params[:title])
        end
      end
    end
    
    context 'Any manage role' do
      let(:user) { create(:course_master) }
      before { sign_in(user) }

      context 'when valid data' do
        let(:params) do
          { course: attributes_for(:course), format: :json }
        end

        it 'created course related with user' do
          expect {
            post :create, params: params
          }.to change(user.courses, :count).by(1)
        end

        it 'return course object' do
          post :create, params: params
          expect(response).to match_json_schema('courses/create/success')
        end
      end

      context 'when invalid data' do
        let(:invalid_params) do
          { course: attributes_for(:invalid_course), format: :json }
        end

        it 'can\'t create course' do
          expect {
            post :create, params: invalid_params
          }.to_not change(user.courses, :count)
        end

        it 'return error' do
          post :create, params: invalid_params
          expect(response).to match_json_schema('courses/create/errors')
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:course_master) }
    let(:course) { create(:course, user_id: user.id) }

    context 'Author' do
      before { sign_in(user) }

      context 'when valid data' do
        let(:params) do
          { course: { title: 'NewValidTitle' }, id: course.id, format: :json }
        end

        it 'can update own course' do
          patch :update, params: params
          course.reload
          expect(course.title).to eq(params[:course][:title])
        end

        it 'return course object' do
          patch :update, params: params
          expect(response).to match_json_schema('courses/update/success')
        end
      end

      context 'when invalid data' do
        let(:invalid_params) do
          { course: { title: nil }, id: course.id, format: :json }
        end

        it 'can\'t update own course' do
          old_title = course.title
          patch :update, params: invalid_params
          course.reload
          expect(course.title).to eq(old_title)
        end

        it 'return errors' do
          patch :update, params: invalid_params
          expect(response).to match_json_schema('courses/update/errors')
        end
      end
    end

    context 'Not author' do
      let(:params) do
        { course: { title: 'NewValidTitle' }, id: course.id, format: :json }
      end
      before { sign_in(create(:course_master)) }

      it 'can\'t update course' do
        old_title = course.title
        patch :update, params: params
        course.reload
        expect(course.title).to eq(old_title)
      end

      it 'return errors' do
        patch :update, params: params
        expect(response).to match_json_schema('courses/update/errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:course_master) }
    let!(:course) { create(:course, user_id: user.id) }
    let(:params) do
      { id: course.id, format: :json }
    end

    context 'Author' do
      before { sign_in(user) }

      it 'can destroy own course' do
        expect{
          delete :destroy, params: params
        }.to change(user.courses, :count).by(-1)
      end

      it 'return course object' do
        delete :destroy, params: params
        expect(response).to match_json_schema('courses/destroy/success')
      end
    end

    context 'Not author' do
      before { sign_in(create(:course_master)) }

      it 'can\'t delete course' do
        expect{
          delete :destroy, params: params
        }.to_not change(user.courses, :count)
      end

      it 'return errors' do
        delete :destroy, params: params
        expect(response).to match_json_schema('courses/destroy/errors')
      end
    end
  end
end
