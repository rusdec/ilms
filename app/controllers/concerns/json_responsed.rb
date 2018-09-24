module JsonResponsed
  extend ActiveSupport::Concern

  include Polymorphed

  included do
    private

    def json_response_by_result(params = {}, resource = nil)
      @json_resource = if resource 
                         resource
                       elsif polymorphic_resource
                         polymorphic_resource
                       else
                         plural_polymorphic_resource
                       end

      if @json_resource.is_a?(ActiveRecord::Relation)
        params[:objects] = @json_resource
      elsif @json_resource.errors.any?
        return json_response_error(@json_resource.errors.full_messages)
      else
        params[:object] = @json_resource
      end

      params = params_processing(params)
      json_response_success(success_message, params)
    end

    def json_response_success(message = '', params = {})
      render json: { status: true, message: message }.merge(params)
    end

    def json_response_error(errors = [], params = {})
      render json: { status: false, errors: errors }.merge(params)
    end

    def json_response_you_can_not_do_it
      json_response_error([I18n.t('access_denied')])
    end

    def with_location(params)
      return params unless params[:with_location]

      resource = @json_resource&.persisted? ? @json_resource : nil

      if params[:location_object]
        resource = params[:location_object]
        params.delete(:location_object)
      elsif(plural_path?(params[:with_location]))
        resource = nil
      end

      params[:location] = send(params[:with_location], resource)

      if params[:with_url_hash]
        params[:location] += "##{params[:with_url_hash]}"
        params.delete(:with_url_hash)
      end

      params.delete(:with_location)
      params
    end

    def with_flash(params)
      return params unless params[:with_flash]

      flash[:notice] = success_message
      params.delete(:with_flash)
      params
    end

    def with_serializer(params)
      return params unless params[:with_serializer]

      if params[:object]
        params[:object] = params[:with_serializer].new(params[:object], {})
      end

      if params[:objects]
        params[:objects] = params[:objects].collect do |object|
          params[:with_serializer].new(object, {})
        end
      end

      params.delete(:with_serializer)
      params
    end

    def without_object(params)
      return params unless params[:without_object]

      %i(object without_object).each { |key| params.delete(key) }
      params
    end

    def params_processing(params)
      %i(
        with_serializer
        with_location
        with_flash
        without_object
      ).each { |method| params = send(method, params) }
      params
    end

    def success_message
      I18n.t('success')
    end

    protected

    def plural_path?(path)
      path.to_s.match?(/s_path$/)
    end
  end
end
