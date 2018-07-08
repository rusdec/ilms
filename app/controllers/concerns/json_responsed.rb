module JsonResponsed
  extend ActiveSupport::Concern

  include Polymorphed

  included do
    private

    def json_response_by_result(params = {}, resource = nil)
      @json_resource = resource || polymorphic_resource

      if @json_resource.errors.any?
        json_response_error(@json_resource.errors.full_messages)
      else
        params[:object] = @json_resource
        params = params_processing(params)
        json_response_success(success_message, params)
      end
    end

    def json_response_success(message = '', params = {})
      render json: { status: true, message: message }.merge(params)
    end

    def json_response_error(errors = [], params = {})
      render json: { status: false, errors: errors }.merge(params)
    end

    def json_response_you_can_not_do_it
      json_response_error(['Access denied'])
    end

    def with_location(params)
      return params unless params[:with_location]

      resource = @json_resource&.persisted? ? @json_resource : nil
      params[:location] = send(params[:with_location], resource)
      params.delete(:with_location)
      params
    end

    def with_flash(params)
      return params unless params[:with_flash]

      flash[:notice] = success_message
      params.delete(:with_flash)
      params
    end

    def without_object(params)
      return params unless params[:without_object]

      %i(object without_object).each { |key| params.delete(key) }
      params
    end

    def params_processing(params)
      %i(
        with_location
        with_flash
        without_object
      ).each { |method| params = send(method, params) }
      params
    end

    def success_message
      'Success'
    end
  end
end
