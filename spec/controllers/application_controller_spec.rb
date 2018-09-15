require_relative 'controller_helper'

class AnyApplicationControllersController < ApplicationController; end

RSpec.describe ApplicationController, type: :controller do
  controller AnyApplicationControllersController do
    def index
      head :ok
    end
  end

  before do
    routes.draw do
      resources :any_application_controllers
    end
  end


  it 'assigns @action_name' do
    get :index
    expect(assigns(:action_name)).to eq('any_application_controllers_index')
  end

  context 'assigns gon attributes' do
    before { get :index }
    after  { Gon.clear  }

    it 'gonifies locale' do
      expect(controller.gon.locale).to eq(I18n.locale)
    end

    it 'gonifies i18n' do
      expect(controller.gon.i18n).to eq(YAML.load_file('config/locales/frontend/i18n.yml').to_json())
    end

    it 'gonifies action_name' do
      expect(controller.gon.action_name).to eq('any_application_controllers_index')
    end
  end
end
