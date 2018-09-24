module Statused
  extend ActiveSupport::Concern

  included do
    include Polymorphed
    include JsonResponsed

    before_action :set_statusable,
                  only: Status.all.pluck(:id).collect { |s| "#{s}!" }

    Status.pluck(:id).each do |status|
      define_method "#{status}", do
        statusable = instance_variable_get("@statusable")
        statusable.send "#{status}!"
        json_response_by_result({}, statusable)
      end

      def set_statusable
        @statusable = polymorphic_resource_class.find(params[:id])
      end
    end
  end
end
