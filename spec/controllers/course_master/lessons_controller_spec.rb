require 'rails_helper'

RSpec.describe CourseMaster::LessonsController, type: :controller do
  describe 'GET #index' do
    non_manage_roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Redirect to root' do
          get :show, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    manage_roles.each do |role|
      context "#{role}" do
        let(:course_master) { create(:course_master) }
        let(:course) { create(:course, user_id: course_master.id) }

        before do
          [course, create(:course, user_id: course_master.id)].each do |course|
            create_list(:lesson, 5, user_id: course_master.id, course: course)
          end
          role = role.underscore.to_sym
          sign_in(create(role))
        end

        it 'Lessons of the course assign to @lessons' do
          get :index, params: { course_id: course.id }
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

    roles.each do |role|
      context "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        it 'Assign Lesson to @lesson' do
          get :show, params: params
          expect(assigns(:lesson)).to eq(lesson)
        end
      end
    end
  end
end
