require 'rails_helper'

RSpec.describe QuestPassagesController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:course_master, :with_full_course) }
    let(:course_passage) { user.course_passages.last }
    let(:quest_passage) { course_passage.lesson_passages.first.quest_passages.last }
    let!(:quest) { quest_passage.quest }
    let(:params) do
      { course_passage_id: course_passage, id: quest_passage }
    end

    context 'when authenticated user' do
      context 'when owner of course_passage' do
        before do
          sign_in(user)
          get :show, params: params
        end

        it 'QuestPassage assigns to @quest_passage' do
          expect(assigns(:quest_passage)).to eq(quest_passage)
        end

        it 'Quest assigns to @quest' do
          expect(assigns(:quest)).to eq(quest)
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
