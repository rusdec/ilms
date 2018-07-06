require 'rails_helper'

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
end
