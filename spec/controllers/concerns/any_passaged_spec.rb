require_relative '../controller_helper'

class AnyPassablesController < ApplicationController; end

RSpec.describe AnyPassablesController, type: :controller do
  controller do
    include Passaged
  end

  with_model :any_passable do
    table do |t|
      t.integer :parent_id
      t.boolean :published, default: true
    end

    model do
      include Passable
    end
  end

  class AnyPassablePassage < Passage; end
  class AnyPassablePassageDecorator < Draper::Decorator; end

  before do
    routes.draw do
      concern :passable do |options|
        member do
          post :learn, action: :learn!
        end

        collection do
          get 'passages/all', action: :passages
        end
      end

      resources :any_passables do
        concerns :passable
      end

      resources :passages
    end
  end

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

        context 'when unpublished' do
          before { any_passable.update(published: false) }

          it 'can\'t create passage' do
            expect{
              post :learn!, params: params
            }.to_not change(Passage, :count)
          end

          before { post :learn!, params: params }
          it_behaves_like 'recipient_of_json_with_errors'
        end

        it 'can create passage related with user' do
          expect{
            post :learn!, params: params
          }.to change(user.passages, :count).by(1)
        end

        it 'created passage has type' do
          post :learn!, params: params
          expect(Passage.last).to be_a(AnyPassablePassage)
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
