module Statusable
  extend ActiveSupport::Concern

  included do
    before_create :before_create_set_status

    belongs_to :status, optional: true

    Status.all.each do |s|
      define_method "#{s.name}?" do
        self.status == s
      end

      define_method "#{s.name}!" do
        change_status_to(s)
      end

      scope "all_#{s.name}", ->() { where(status: Status.send(s.name)) }
    end

    def statuses
      Status
    end

    protected

    def change_status_to(new_status)
      transaction do
        before_update_status
        self.update!(status: new_status)
        after_update_status
      end
    end

    # Template method
    def before_update_status; end

    # Template method
    def after_update_status; end

    def default_status
      Status.in_progress
    end

    def before_create_set_status
      self.status = default_status unless self.status
    end
  end
end
