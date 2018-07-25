require_relative 'controller_helper'

RSpec.describe QuestSolutionsController, type: :controller do
  describe 'POST #create' do
    let!(:quest_passage) { create(:quest_passage) }
    let(:owner) { quest_passage.lesson_passage.course_passage.educable }
    let(:params) do
      { course_passage_id: quest_passage.lesson_passage.course_passage,
        quest_passage_id: quest_passage,
        quest_solution: attributes_for(:quest_solution) }
    end

    context 'when authenticated user' do
      context 'when owner of course' do
        before { sign_in(owner) }

        context 'when json' do
          before { params[:format] = :json }

          context 'when valid data' do
            context 'and quest passage have not quest solution' do
              it_behaves_like 'quest_solution_creatable'
            end

            context 'and quest passage already have quest solution' do
              let!(:existed_quest_solution) do
                create(:quest_solution, quest_passage: quest_passage)
              end

              context 'and it quest solution is accepted' do
              end

              context 'and it quest solution is declined' do
                before { existed_quest_solution.decline! }
                it_behaves_like 'quest_solution_creatable'
              end

              context 'and it quest solution is unverified' do
                it_behaves_like 'quest_solution_non_creatable'
              end
            end
          end

          context 'when invalid data' do
            before do
              params[:quest_solution] = attributes_for(:invalid_quest_solution)
            end

            it 'can\'t create quest_solution' do
              expect{
                post :create, params: params
              }.to_not change(QuestSolution, :count)
            end

            it 'return error object' do
              post :create, params: params
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end
      end

      context 'when not owner of course' do
        before { sign_in(create(:user)) }

        context 'when json' do
          before { params[:format] = :json }
          it_behaves_like 'quest_solution_non_creatable'
        end
      end
    end

    context 'when not authenticated user' do
      context 'when json' do
        before { params[:format] = :json }

        it 'can\'t create quest_solution' do
          expect{
            post :create, params: params
          }.to_not change(QuestSolution, :count)
        end

        it 'return error object' do
          post :create, params: params
          expect(response).to match_json_schema('shared/devise_errors')
        end
      end
    end
  end
end
