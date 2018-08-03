require_relative 'controller_helper'

RSpec.describe PassagesController, type: :controller do
  with_model :any_passable do
    table do |t|
      t.integer :parent_id
    end

    model do
      include Passable
    end
  end

  before do
    routes.draw do
      resources :any_passables
      resources :passages, only: %i(index show)
      root to: 'home#index'
    end
  end

  before { create(:status, :in_progress) }
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
          expect(assigns(:passage)).to eq(passage)    
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
end
