require_relative '../controller_helper'

class AnyJsonResponsedsController < ApplicationController; end

RSpec.describe AnyJsonResponsedsController, type: :controller do
  controller do
    include JsonResponsed
    skip_authorization_check

    def success
      @any_json_responsed = JsonResponsibleBot.new
      if params[:params]
        json_response_by_result(param: params[:params], without_object: true)
      else
        json_response_by_result(without_object: true)
      end
    end

    def with_location_test
      @any_json_responsed = JsonResponsibleBot.new
      json_response_by_result({ param: params[:params],
                                with_location: :with_location_url,
                                without_object: true },
                                @any_json_responsed)
    end

    def with_flash_test
      @any_json_responsed = JsonResponsibleBot.new
      json_response_by_result(with_flash: true)
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

    def with_location_url(*)
      'http://any'
    end
  end
  
  before do
    routes.draw do
      %i[success
         error
         you_can_not_do_it
         other_variable
         with_location_test
         with_flash_test].each do |method|
        get method, to: "any_json_responseds##{method}"
      end
    end
  end

  describe 'GET #with_flash_test' do
    it 'set flash message' do
      get :with_flash_test, format: :json

      expect(flash[:notice]).to eq('Success')
    end
  end

  describe 'GET #error' do
    it 'not set flash message' do
      get :error, format: :json

      expect(flash[:notice]).to be_nil
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

  describe 'GET #with_location_test' do
    it 'respond with success, params and location' do
      get :with_location_test, params: { params: 'Any param' }, format: :json

      expect(response.body).to eq(
        json_success_hash.merge(param: 'Any param', location: 'http://any').to_json
      )
    end
  end

  describe 'GET #you_can_not_do_it' do
    it 'respond with error' do
      get :you_can_not_do_it, format: :json

      expect(response.body).to eq({ status: false,
                                    errors: ['Access denied'] }.to_json)
    end
  end

  describe 'GET #other_variable' do
    it 'respond with success' do
      get :success, format: :json

      expect(response.body).to eq(json_success_hash.to_json)
    end
  end
end
