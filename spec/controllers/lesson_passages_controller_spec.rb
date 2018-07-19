require_relative 'controller_helper'

RSpec.describe LessonPassagesController, type: :controller do
  describe 'GET #show' do
    let!(:user) { create(:course_master, :with_full_course) }
    let(:course_passage) { user.course_passages.last }
    let(:lesson_passage) { course_passage.lesson_passages.first }
    let(:params) do
      { course_passage_id: course_passage, id: lesson_passage }
    end

    context 'when authenticated user' do
      context 'when owner of course_passage' do
        before do
          sign_in(user)
          get :show, params: params
        end

        it 'Lesson assigns to @lesson' do
          expect(assigns(:lesson)).to eq(lesson_passage.lesson)
        end
      end

      context 'when not owner of course_passage' do
        before do
          sign_in(create(:course_master))
          get :show, params: params
        end

        it 'redirect to root' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when not authenticated user' do
      before do
        get :show, params: params
      end

      it 'redirect to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
