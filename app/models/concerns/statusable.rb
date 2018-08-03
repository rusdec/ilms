module Statusable
  extend ActiveSupport::Concern

  included do
    before_validation :set_status

    belongs_to :status

    protected

    def default_status
      Status.find(:in_progress)
    end

    def set_status
      self.status = default_status
    end
  end
end
