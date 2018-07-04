require_relative '../controller_helper'
require 'with_model'

class AnyJsonResponsedsController < ApplicationController; end

RSpec.describe AnyJsonResponsedsController, type: :controller do
  controller do
    include JsonResponsed
    skip_authorization_check

    def success
      @any_json_responsed = JsonResponsibleBot.new
      if params[:params]
        json_response_by_result(param: params[:params])
      else
        json_response_by_result
      end
    end

    def other_variable
      @any_variable = JsonResponsibleBot.new
      json_response_by_result({}, @any_variable)
    end

    def error
      @any_json_responsed = JsonResponsibleBot.new(errors_count: 1)
      json_response_by_result
    end

    def you_can_not_do_it
      json_response_you_can_not_do_it
    end
  end
  
  before do
    routes.draw do
      %i[success error you_can_not_do_it other_variable].each do |method|
        get method, to: "any_json_responseds##{method}"
      end
    end
  end

  describe 'GET #error' do
    it 'respond with error' do
      get :error, format: :json

      expect(response.body).to eq({status: false, errors: ['AnyErrorText']}.to_json)
    end
  end

  describe 'GET #success' do
    it 'respond with success' do
      get :success, format: :json

      expect(response.body).to eq(json_success_hash.to_json)
    end

    context 'when params is given' do
      it 'respond with success and params' do
        get :success, params: { params: 'Any param' }, format: :json

        expect(response.body).to eq(
          json_success_hash.merge(param: 'Any param').to_json
        )
      end
    end
  end

  describe 'GET #you_can_not_do_it' do
    it 'respond with error' do
      get :you_can_not_do_it, format: :json

      expect(response.body).to eq({ status: false,
                                    errors: ['You can not do it'] }.to_json)
    end
  end

  describe 'GET #other_variable' do
    it 'respond with success' do
      get :success, format: :json

      expect(response.body).to eq(json_success_hash.to_json)
    end
  end
end
