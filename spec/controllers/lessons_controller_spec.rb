require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  describe 'GET #index' do
    roles.each do |role|
      context "#{role}" do
        let(:user) { create(:course_master) }
        let(:course) { create(:course, author: user) }

        before do
          create(:course, :with_lessons, author: user)
          create_list(:lesson, 5, author: user, course: course)
          sign_in(create(role.underscore.to_sym))
        end

        it 'Lessons of the course assign to @lessons' do
          get :index, params: { course_id: course }
          expect(assigns(:lessons)).to eq(course.lessons)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:course_master) }
    let(:lesson) { create(:course, :with_lesson, author: user).lessons.last }
    let(:params) { { id: lesson } }

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
