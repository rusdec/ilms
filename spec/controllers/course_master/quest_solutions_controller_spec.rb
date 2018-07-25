require_relative '../controller_helper'

RSpec.describe CourseMaster::QuestSolutionsController, type: :controller do
  describe 'GET #index' do
    let!(:quest_solutions) do
      create(:quest_passage, :with_solutions).quest_solutions
    end
    let(:author) { quest_solutions.last.quest_passage.quest.author }

    context 'when authenticated user' do 
      context 'when course master' do
        before do
          sign_in(author)
          create_list(:quest_solution, 3)
          get :index
        end

        it 'assings QuestSolution of quest author to @quest_solutions' do
          ids = quest_solutions.pluck(:id)
          expect(assigns(:quest_solutions).to_a).to eq(
            QuestSolution.where(id: ids).order(verified: :asc, updated_at: :desc).to_a
          )
        end

        it 'assigns QuestSolution should be decorated' do
          expect(assigns(:quest_solutions)).to be_decorated
        end
      end # context 'when course master'

      context 'when user' do
        before do
          sign_in(create(:user))
          get :index
        end

        it 'redirect to root path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { get :index }

      it 'redirect to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    let!(:quest_passage) { create(:quest_passage, :with_solutions) }
    let!(:quest_solution) { quest_passage.quest_solutions.last }
    let(:author) { quest_solution.quest_passage.quest.author }
    let(:params) { { id: quest_solution } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before do
            sign_in(author)
            get :show, params: params
          end

          it 'assigns QuestSolution to @quest_solution' do
            expect(assigns(:quest_solution)).to eq(quest_solution)
          end

          it 'assigns QuestSolution should be decorated' do
            expect(
              assigns(:quest_solution)
            ).to be_decorated_with QuestSolutionDecorator
          end
        end

        context 'when not author' do
          before do
            sign_in(create(:course_master))
            get :show, params: params
          end

          it 'redirect to root path' do
            expect(response).to redirect_to(root_path)
          end
        end
      end # context 'when course master'

      context 'when user' do
        before { get :show, params: params }

        it 'redirect to root path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { get :show, params: params }

      it 'redirect to root path' do
        expect(response).to redirect_to(root_path)
      end
    end # context 'when not authenticated user'
  end

  describe 'PATCH #accept' do
    let!(:quest_passage) { create(:quest_passage, :with_solutions) }
    let!(:quest_solution) { quest_passage.quest_solutions.last }
    let(:author) { quest_solution.quest_passage.quest.author }
    let(:params) { { id: quest_solution, format: :json } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before { sign_in(author) }

          context 'when not verified' do
            before do
              patch :accept, params: params
              quest_solution.reload
            end

            it 'update quest_solution verified to true' do
              expect(quest_solution).to be_verified
            end

            it 'update quest_solution passed to true' do
              expect(quest_solution).to be_passed
            end

            it 'return success' do
              expect(response).to match_json_schema('quest_solutions/accept/success')
            end
          end

          context 'when verified' do
            it 'return error' do
              quest_solution.accept!
              patch :accept, params: params
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end

        context 'when not author' do
          before do
            sign_in(create(:course_master))
            patch :accept, params: params
            quest_solution.reload
          end

          it 'can\'t update quest_solution verified' do
            expect(quest_solution).to_not be_verified
          end

          it 'can\'t update quest_solution passed' do
            expect(quest_solution).to_not be_passed
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when course master'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before do
        patch :accept, params: params
        quest_solution.reload
      end

      it 'can\'t update quest_solution verified' do
        expect(quest_solution).to_not be_verified
      end

      it 'can\'t update quest_solution passed' do
        expect(quest_solution).to_not be_passed
      end

      it 'return error object' do
        expect(response).to match_json_schema('shared/errors')
      end
    end # context 'when not authenticated user'
  end

  describe 'PATCH #decline' do
    let!(:quest_passage) { create(:quest_passage, :with_solutions) }
    let!(:quest_solution) { quest_passage.quest_solutions.last }
    let(:author) { quest_solution.quest_passage.quest.author }
    let(:params) { { id: quest_solution, format: :json } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before { sign_in(author) }

          context 'when not verified' do
            before do
              patch :decline, params: params
              quest_solution.reload
            end

            it 'update quest_solution verified to true' do
              expect(quest_solution).to be_verified
            end

            it 'update quest_solution passed to false' do
              expect(quest_solution).to_not be_passed
            end

            it 'return success' do
              expect(response).to match_json_schema('quest_solutions/accept/success')
            end
          end

          context 'when verified' do
            it 'return error' do
              quest_solution.accept!
              patch :accept, params: params
              expect(response).to match_json_schema('shared/errors')
            end
          end
        end

        context 'when not author' do
          before do
            sign_in(create(:course_master))
            patch :decline, params: params
            quest_solution.reload
          end

          it 'can\'t update quest_solution verified' do
            expect(quest_solution).to_not be_verified
          end

          it 'can\'t update quest_solution passed' do
            expect(quest_solution).to_not be_passed
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when course master'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before do
        patch :decline, params: params
        quest_solution.reload
      end

      it 'can\'t update quest_solution verified' do
        expect(quest_solution).to_not be_verified
      end

      it 'can\'t update quest_solution passed' do
        expect(quest_solution).to_not be_passed
      end

      it 'return error object' do
        expect(response).to match_json_schema('shared/errors')
      end
    end # context 'when not authenticated user'
  end
end
