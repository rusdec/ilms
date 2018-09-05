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
      end

      resources :any_passables do
        concerns :passable
      end

      resources :passages
    end
  end

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
