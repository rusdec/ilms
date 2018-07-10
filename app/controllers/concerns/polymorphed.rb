module Polymorphed
  extend ActiveSupport::Concern

  included do
    def polymorphic_resource
      instance_variable_get("@#{polymorphic_resource_name}")
    end

    def polymorphic_resource_name
      controller_name.underscore.singularize
    end

    def polymorphic_resource_class
      controller_name.classify.constantize
    end
  end
end
