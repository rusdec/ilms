require_relative 'controller_helper'

RSpec.describe CoursesController, type: :controller do

  describe 'GET #index' do
    roles.each do |role|
      context "#{role}" do
        before do
          role = role.underscore.to_sym
          create_list(:course, 5, user_id: create(:administrator).id)
          sign_in(create(role))
        end

        it 'Cource assign to @cources' do
          get :index
          expect(assigns(:courses)).to eq(Course.all)
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:course) { create(:course, user_id: create(:course_master).id) }
    let(:params) { { id: course.id } }

    roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Assign Course to @course' do
          get :show, params: params
          expect(assigns(:course)).to eq(course)
        end
      end
    end
  end
end
