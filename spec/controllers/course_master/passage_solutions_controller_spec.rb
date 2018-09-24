require_relative '../controller_helper'

RSpec.describe CourseMaster::PassageSolutionsController, type: :controller do
  let!(:passable) { create(:quest, author: create(:course_master)) }
  let!(:passage) { create(:quest_passage, passable: passable) }

  describe 'GET #index' do
    let!(:passage_solution) { create(:passage_solution, passage: passage) }
    let(:passage_solutions) { passage.solutions }
    let(:author) { passable.author }

    context 'when authenticated user' do 
      context 'when course master' do
        before do
          sign_in(author)
          get :index
        end

        it 'assings PassageSolution of passables author to @passage_solutions' do
          expect(
            assigns(:passage_solutions).object.to_a
          ).to eq(PassageSolution.for_auditor(author, :quests).order(created_at: :desc).to_a)
        end

        it 'assigns PassageSolution should be decorated' do
          assigns(:passage_solutions).each do |passage_solution|
            expect(passage_solution).to be_decorated
          end
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
    let(:passage_solution) { create(:passage_solution, passage: passage) }
    let(:author) { passage.passable.author }
    let(:params) { { id: passage_solution } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before do
            sign_in(author)
            get :show, params: params
          end

          it 'assigns PassageSolution to @passage_solution' do
            expect(assigns(:passage_solution)).to eq(passage_solution)
          end

          it 'assigns PassageSolution should be decorated' do
            expect(
              assigns(:passage_solution)
            ).to be_decorated_with PassageSolutionDecorator
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
    let(:passage_solution) { create(:passage_solution, passage: passage) }
    let(:author) { passable.author }
    let(:params) { { id: passage_solution, format: :json } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before { sign_in(author) }

          context 'when unverified' do
            before do
              patch :accept, params: params
              passage_solution.reload
            end

            it 'update passage_solution passed to true' do
              expect(passage_solution).to be_accepted
            end

            it 'return success' do
              expect(response).to match_json_schema('passage_solutions/accept/success')
            end
          end
        end

        context 'when not author' do
          before do
            sign_in(create(:course_master))
            patch :accept, params: params
            passage_solution.reload
          end

          it 'can\'t accept passage_solution' do
            expect(passage_solution).to_not be_accepted
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
        passage_solution.reload
      end

      it 'can\'t accept passage_solution' do
        expect(passage_solution).to be_unverified
      end

      it 'return error object' do
        expect(response).to match_json_schema('shared/errors')
      end
    end # context 'when not authenticated user'
  end

  describe 'PATCH #decline' do
    let(:passage_solution) { create(:passage_solution, passage: passage) }
    let(:author) { passable.author }
    let(:params) { { id: passage_solution, format: :json } }

    context 'when authenticated user' do
      context 'when course master' do
        context 'when author' do
          before { sign_in(author) }

          context 'when unverified' do
            before do
              patch :decline, params: params
              passage_solution.reload
            end

            it 'decline passage_solution' do
              expect(passage_solution).to be_declined
            end

            it 'return success' do
              expect(response).to match_json_schema('passage_solutions/accept/success')
            end
          end
        end

        context 'when not author' do
          before do
            sign_in(create(:course_master))
            patch :decline, params: params
            passage_solution.reload
          end

          it_behaves_like 'passage_solution_unverifiable'
        end
      end # context 'when course master'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before do
        patch :decline, params: params
        passage_solution.reload
      end

      it_behaves_like 'passage_solution_unverifiable'
    end # context 'when not authenticated user'
  end
end
