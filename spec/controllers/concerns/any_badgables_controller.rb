require_relative '../controller_helper'

class AnyBadgablesController < ApplicationController; end

RSpec.describe AnyBadgablesController, type: :controller do
  controller do
    include Badged
  end

  with_model :any_badgable do
    table do |t|
      t.references :user
    end

    model do
      include Badgable
      include Authorable
    end
  end

  before do
    routes.draw do
      concern :badgable do |options|
        member do
          get 'new_badge', to: "#{options[:controller]}#new_badge"
          post '/', to: "#{options[:controller]}#create_badge"
        end
      end
      resources :any_badgables do
        #member do
        #  get 'new_badge', to: "any_badgables#new_badge"
        #end
        concerns :badgable, { controller: :any_badgables }
      end
    end
  end

  describe 'GET #new_badge' do
    context 'when authenticated user' do
      context 'when author of badgable' do
        before do
          badgable = AnyBadgable.create(author: create(:user))
          get :new_badge, params: { id: badgable }
        end

        it 'assigns new Badge to @badge' do
          expect(assigns(:badge)).to be_a_new(Badge)
        end

=begin
        it 'assigns badgable to @badgable' do
          expect(assigns(:badgable)).to eq(badgable)
        end

        it 'assigned @badge relates with @badgable' do
          expect(assigns(:badge).badgable).to eq(badgable)
        end
=end
      end # context 'when author of badgable'

      context 'when not author of badgable' do
        before do
          #get :new_badge
        end

        #it_behaves_like 'unauthorizable'
      end # context 'when not author of badgable'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
    end # context 'when not authenticated user'
  end

  describe 'POST #create' do
    context 'when authenticated user' do
      context 'when json' do
        context 'when author of badgable' do
          context 'when data is vaild' do
          end # context 'when data is vaild'

          context 'when data is invalid' do
          end # context 'when data is invalid'
        end # context 'when author of badgable'

        context 'when not author of badgable' do
        end
      end # context 'when json'
    end # context 'when not authenticated user'

    context 'when not authenticated user' do
    end # context 'when not authenticated user'
  end
end
