module JsonResponsed
  extend ActiveSupport::Concern

  include Polymorphed

  included do
    private

    def json_response_by_result(params = {}, resource = nil)
      resource ||= polymorphic_resource
      resource.errors.any? ? json_response_error(resource.errors.full_messages)
                           : json_response_success('Success', params)
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
  end
end
