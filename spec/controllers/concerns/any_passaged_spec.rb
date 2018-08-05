require_relative '../controller_helper'

class AnyPassablesController < ApplicationController; end

RSpec.describe AnyPassablesController, type: :controller do
  controller do
    include Passaged
  end

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
      concern :passable do |options|
        member do
          post :learn, to: "#{options[:controller]}#learn!"
        end

        collection do
          get 'passages/all', to: "#{options[:controller]}#passages"
        end
      end

      resources :any_passables do
        concerns :passable, { controller: :any_passables }
      end

      resources :passages
    end
  end

  before { create(:status, :in_progress) }

  describe 'GET passages' do
    let(:view_path) { Rails.root.join('app/views/any_passables') }
    before do
      FileUtils.mkdir_p("#{view_path}/passages")
      FileUtils.touch("#{view_path}/passages/index.slim")
    end
    after { FileUtils.rm_r(view_path) }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      before do
        3.times { create(:passage, passable: AnyPassable.create, user: user) }
        3.times { create(:passage, passable: AnyPassable.create, user: create(:user)) }
      end

      context 'when owner of passages' do
        before do
          sign_in(user)
          get :passages
        end

        it 'assign all users Passage with type AnyPassagle to @passages' do
          expect(
            assigns(:passages)
          ).to eq(user.passages.where(passable_type: 'AnyPassable'))
        end

        it 'render any_passables/passages/index' do
          expect(response).to render_template("any_passables/passages/index")
        end
      end # context 'when owner of passages'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      it 'redirect to sign_in page' do
        get :passages
        expect(response).to redirect_to(new_user_session_path)
      end
    end # context 'when not authenticated user'
  end # describe 'GET passages'

  describe 'POST #learn!' do
    let!(:any_passable) { AnyPassable.create }
    let(:params) { { id: any_passable } }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      before { sign_in(user) }
      
      context 'when json' do
        before { params[:format] = :json }

        it 'can create passage related with user' do
          expect{
            post :learn!, params: params
          }.to change(user.passages, :count).by(1)
        end

        it 'created passage related with passable' do
          expect{
            post :learn!, params: params
          }.to change(any_passable.passages, :count).by(1)
        end
      end # context 'when json'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      let(:params) { { id: any_passable } }

      context 'when json' do
        before { params[:format] = :json }

        it 'can\'t create passage' do
          expect{
            post :learn!, params: params
          }.to_not change(Passage, :count)
        end
      end
    end # context 'when not authenticated user'
  end
end
