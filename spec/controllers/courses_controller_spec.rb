require_relative 'controller_helper'

RSpec.describe CoursesController, type: :controller do

  describe 'GET #index' do
    before do
      create_list(:course, 3, :unpublished, author: create(:administrator))
      create_list(:course, 3, author: create(:administrator))
      sign_in(create(:user))
      get :index
    end

    it 'Published Cources assign to @cources' do
      expect(assigns(:courses)).to eq(Course.all_published)
    end

    it 'decorates @courses' do
      expect(assigns(:courses)).to be_decorated
    end
  end

  describe 'GET #show' do
    let!(:course) { create(:course, author: create(:course_master)) }
    before do
      sign_in(create(:user))
      get :show, params: { id: course }
    end

    it 'assigns Course to @course' do
      expect(assigns(:course)).to eq(course)
    end

    it 'decorates @course' do
      expect(assigns(:course)).to be_decorated_with CourseDecorator
    end
  end
end
