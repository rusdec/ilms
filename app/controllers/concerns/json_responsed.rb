module JsonResponsed
  extend ActiveSupport::Concern

  include Polymorphed

  included do
    private

    def json_response_by_result(params = {}, resource = nil)
      @json_responsable_resource = resource || polymorphic_resource

      if @json_responsable_resource.errors.any?
        json_response_error(@json_responsable_resource.errors.full_messages)
      else
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
      json_response_error(['You can not do it'])
    end

    def with_location(params)
      if params[:with_location]
        resource = if @json_responsable_resource&.persisted?
                     @json_responsable_resource
                   else
                     nil  
                   end
        params[:location] = send(params[:with_location], resource)
        params.delete(:with_location)
      end
      params
    end

    def with_flash(params)
      if params[:with_flash]
        flash[:notice] = success_message
        params.delete(:with_flash)
      end
      params
    end

    def params_processing(params)
      %i(with_location with_flash).each { |method| params = send(method, params) }
      params
    end

    def success_message
      'Success'
    end
  end
end
