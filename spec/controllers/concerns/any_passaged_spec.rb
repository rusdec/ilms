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
          post :passage, to: "#{options[:controller]}#passage"
        end
      end

      resources :any_passables do
        concerns :passable, { controller: :any_passables }
      end

      resources :passages
    end
  end

  before { create(:status, :in_progress) }
  let!(:any_passable) { AnyPassable.create }

  describe 'POST #passage' do
    let(:params) { { id: any_passable } }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      before { sign_in(user) }
      
      context 'when json' do
        before { params[:format] = :json }

        it 'can create passage' do
          expect{
            post :passage, params: params
          }.to change(user.passages, :count).by(1)
        end

        it 'created passage related with passable' do
          expect{
            post :passage, params: params
          }.to change(any_passable.passages, :count).by(1)
        end
      end
    end
  end
end
