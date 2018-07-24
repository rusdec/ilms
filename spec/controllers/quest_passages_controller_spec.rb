require 'rails_helper'

RSpec.describe QuestPassagesController, type: :controller do
  describe 'GET #show' do
    let!(:quest_passage) { create(:quest_passage) }
    let(:user) { quest_passage.lesson_passage.course_passage.educable }
    let(:params) do
      { course_passage_id: quest_passage.lesson_passage.course_passage,
        id: quest_passage }
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
          expect(assigns(:quest)).to eq(quest_passage.quest)
        end

        it 'New QuestSolution assign to @quest_solution' do
          expect(assigns(:quest_solution)).to be_a_new(QuestSolution)
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
