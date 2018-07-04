require 'rails_helper'

class AnyPolymorphedsController < ApplicationController; end

RSpec.describe AnyPolymorphedsController, type: :controller do
  controller AnyPolymorphedsController do
    include Polymorphed
    skip_authorization_check

    def index
      @any_polymorphed = 'AnyValue'
      @polymorphic_resource = polymorphic_resource
      head :ok
    end
  end

  describe 'GET #index' do
    it '@any_polymorphed is assign' do
      get :index
      expect(assigns(:any_polymorphed)).to eq('AnyValue')
    end

    it '@polymorphic_resource equal @any_polymorphed' do
      get :index
      expect(assigns(:any_polymorphed)).to eq(assigns(:polymorphic_resource))
    end
  end
end
