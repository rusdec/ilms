require_relative 'controller_helper'

class AnyPassablePassageDecorator < Draper::Decorator
  delegate_all
end

RSpec.describe PassagesController, type: :controller do
  with_model :any_passable do
    table do |t|
      t.integer :parent_id
    end

    model do
      include Passable

      def ready_to_pass?
        true
      end
    end
  end

  class AnyPassablePassage < Passage; end

  before do
    routes.draw do
      resources :any_passables
      resources :passages, only: %i(index show) do
        member do
          patch :try_pass, action: :try_pass
        end
      end
      root to: 'home#index'
    end
  end

  let!(:user) { create(:user) }

  describe 'GET #show' do
    let!(:passage) { create(:passage, passable: AnyPassable.create, user: user) }
    let(:params) { { id: passage } }

    context 'when authenticated user' do
      context 'and user is owner of passable' do
        let(:view_path) { Rails.root.join('app/views/any_passables') }

        before do
          FileUtils.mkdir_p("#{view_path}/passages")
          FileUtils.touch("#{view_path}/passages/show.slim")
          sign_in(user)
          get :show, params: params
        end

        after { FileUtils.rm_r(view_path) }
        
        it 'assign Passage to @passage' do
          expect(assigns(:passage)).to eq(AnyPassablePassage.find(passage.id))
        end

        it 'should be decorated' do
          expect(assigns(:passage)).to be_decorated_with AnyPassablePassageDecorator
        end

        it 'render any_passables/passages/show' do
          expect(response).to render_template('any_passables/passages/show')
        end
      end

      context 'and user in not owner of passable' do
        before do
          sign_in(create(:user))
          get :show, params: params
        end

        it 'redirect to root' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET #index' do
    before do
      3.times do
        create(:passage, passable: AnyPassable.create, user: user)
      end
    end

    context 'when authenticated user' do
      let(:view_path) { Rails.root.join('app/views/any_passables') }

      before do
        # todo: double passages?
        FileUtils.mkdir_p("#{view_path}/passages")
        FileUtils.touch("#{view_path}/passages/index.slim")
        sign_in(user)
        get :index, params: { passable_type: 'any_passables' }
      end

      after { FileUtils.rm_r(view_path) }
      
      it 'assign Passage to @passages' do
        expect(
          assigns(:passages)
        ).to eq(Passage.where(user: user, passable_type: AnyPassable))
      end

      it 'render any_passables/passages/index' do
        expect(response).to render_template('any_passables/passages/index')
      end
    end
  end

  describe 'PATCH #try_chain_pass' do
    let!(:passage) { create(:passage, passable: AnyPassable.create, user: user) }
    let(:params) { { id: passage } }

    context 'when authenticated user' do
      before { sign_in(user) }

      context 'when json' do
        before { params[:format] = :json }

        context 'and passages owner' do
          it 'passage receives try_chain_pass!' do
            allow(assigns(:passage)).to receive(:try_chain_pass!)
            patch :try_pass, params: params
          end

          it 'returns object' do
            patch :try_pass, params: params
            expect(response).to match_json_schema('passages/try_pass/success')
          end
        end

        context 'and not passages owner' do
        end
      end
    end
    context 'when not authenticated user' do
    end
  end
end
