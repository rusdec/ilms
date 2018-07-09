require_relative 'controller_helper'

RSpec.describe CoursesController, type: :controller do

  describe 'GET #index' do
    roles.each do |role|
      context "#{role}" do
        before do
          create_list(:course, 5, author: create(:administrator))
          sign_in(create(role.underscore.to_sym))
          get :index
        end

        it 'Cource assign to @cources' do
          expect(assigns(:courses)).to eq(Course.all)
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:course) { create(:course, author: create(:course_master)) }

    roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Assign Course to @course' do
          get :show, params: { id: course }
          expect(assigns(:course)).to eq(course)
        end
      end
    end
  end
end
