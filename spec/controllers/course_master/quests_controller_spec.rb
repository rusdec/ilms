require_relative '../controller_helper'

RSpec.describe CourseMaster::QuestsController, type: :controller do
  let!(:author) { create(:course_master, :with_quest) }
  let(:quest) { author.quests.last }

  describe 'GET #index' do
    before do
      create(:course_master, :with_quests)
      sign_in(author)
      get :index
    end
    
    it 'Current users quests assigns to @quests' do
      expect(assigns(:quests)).to eq(author.quests)
    end
  end

  describe 'GET #new' do
    before do
      sign_in(author)
      get :new
    end

    it 'New Quest assigns to @quest' do
      expect(assigns(:quest)).to be_a_new(Quest)
    end

    it 'New Quest related with author' do
      expect(assigns(:quest).author).to eq(author)
    end
  end

  describe 'GET #edit' do
    context 'when author' do
      before do
        sign_in(author)
        get :edit, params: { id: quest }
      end

      it 'Quest assigns to @quest' do
        expect(assigns(:quest)).to eq(quest)
      end
    end

    context 'when not author' do
      before do
        sign_in(create(:course_master))
        get :edit, params: { id: quest }
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when author' do
      before do
        sign_in(author)
        get :show, params: { id: quest }
      end

      it 'Quest assign to @quest' do
        expect(assigns(:quest)).to eq(quest)
      end
    end

    context 'when not author' do
      before do
        sign_in(author)
        get :show, params: { id: quest }
      end

      it 'Quest assign to @quest' do
        expect(assigns(:quest)).to eq(quest)
      end
    end
  end

  describe 'POST #create' do
    before { sign_in(author) }

    context 'with valid data' do
      let(:attributes) { attributes_for(:quest) }

      context 'when json' do
        it 'can create quest' do
          expect{
            post :create, params: { quest: attributes, format: :json }
          }.to change(author.quests, :count).by(1)
        end

        it 'return success object' do
          post :create, params: { quest: attributes, format: :json }
          expect(response).to match_json_schema('quests/create/success')
        end
      end
    end # context 'with valid data'

    context 'with invalid data' do
      let(:attributes) { attributes_for(:invalid_quest) }

      context 'when json' do
        it 'can\'t create quest' do
          expect{
            post :create, params: { quest: attributes, format: :json }
          }.to_not change(author.quests, :count)
        end

        it 'return error object' do
          post :create, params: { quest: attributes, format: :json }
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end # context 'with invalid data'
  end

  describe 'PATCH #update' do
    let!(:old_title) { quest.title }
    let(:new_title) { 'NewQuestTitle' }

    context 'when author' do
      before { sign_in(author) }

      context 'with valid data' do
        let(:attributes) { { title: new_title } }

        context 'when json' do
          before do
            patch :update, params: { id: quest, quest: attributes, format: :json }
          end

          it 'can update quest' do
            quest.reload
            expect(quest.title).to eq(new_title)
          end

          it 'return success object' do
            expect(response).to match_json_schema('quests/update/success')
          end
        end
      end #  context 'with valid data'

      context 'with invalid data' do
        let(:attributes) { { title: nil } }

        context 'when json' do
          before do
            patch :update, params: { id: quest, quest: attributes, format: :json }
          end

          it 'can update quest' do
            quest.reload
            expect(quest.title).to eq(old_title)
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when invalid data'
    end

    context 'when not author' do
      before do
        sign_in(create(:course_master))
        patch :update, params: { id: quest, quest: { title: new_title }, format: :json }
      end

      context 'when json' do
        it 'can\'t update quest' do
            expect(quest.title).to eq(old_title)
        end

        it 'return error object' do
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when author' do
      before { sign_in(author) }

      context 'when json' do
        it 'can delete quest' do
          expect{
            delete :destroy, params: { id: quest, format: :json }
          }.to change(author.quests, :count).by(-1)
        end

        it 'return success object' do
          delete :destroy, params: { id: quest, format: :json }
          expect(response).to match_json_schema('quests/destroy/success')
        end
      end
    end

    context 'when not author' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        it 'can\'t delete quest' do
          expect{
            delete :destroy, params: { id: quest, format: :json }
          }.to_not change(author.quests, :count)
        end

        it 'return error object' do
          delete :destroy, params: { id: quest, format: :json }
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end
  end
end
