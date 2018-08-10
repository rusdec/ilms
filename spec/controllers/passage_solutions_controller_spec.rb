require_relative 'controller_helper'

RSpec.describe PassageSolutionsController, type: :controller do
  with_model :any_passable do
    model { include Passable }
  end

  describe 'POST #create' do
    let!(:passage) { create(:passage, passable: AnyPassable.create) }
    let(:owner) { passage.user }
    let(:params) do
      { passage_id: passage,
        passage_solution: attributes_for(:passage_solution) }
    end

    context 'when authenticated user' do
      context 'when owner of course' do
        before { sign_in(owner) }

        context 'when json' do
          before { params[:format] = :json }

          context 'when valid data' do
            context 'and quest passage have not quest solution' do
              it_behaves_like 'passage_solution_creatable'
            end

            context 'and quest passage already have quest solution' do
              let!(:existed_passage_solution) do
                create(:passage_solution, passage: passage)
              end

              context 'and it quest solution is accepted' do
                before { existed_passage_solution.accepted! }
                it_behaves_like 'passage_solution_creatable'
              end

              context 'and it quest solution is declined' do
                before { existed_passage_solution.declined! }
                it_behaves_like 'passage_solution_creatable'
              end

              context 'and it quest solution is unverified' do
                it_behaves_like 'passage_solution_non_creatable'
              end
            end
          end

          context 'when invalid data' do
            before do
              params[:passage_solution] = attributes_for(:invalid_passage_solution)
            end

            it 'can\'t create passage_solution' do
              expect{
                post :create, params: params
              }.to_not change(PassageSolution, :count)
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
          it_behaves_like 'passage_solution_non_creatable'
        end
      end
    end

    context 'when not authenticated user' do
      context 'when json' do
        before { params[:format] = :json }

        it 'can\'t create passage_solution' do
          expect{
            post :create, params: params
          }.to_not change(PassageSolution, :count)
        end

        it 'return error object' do
          post :create, params: params
          expect(response).to match_json_schema('shared/devise_errors')
        end
      end
    end
  end
end
