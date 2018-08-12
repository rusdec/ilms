module Statusable
  extend ActiveSupport::Concern

  included do
    before_create :before_create_set_status

    belongs_to :status, optional: true

    Status.all.each do |s|
      define_method "#{s.name}?" do
        return false unless self.status
        self.status.name == s.name
      end

      define_method "#{s.name}!" do
        change_status_to(s.name)
      end

      scope "all_#{s.name}", ->() { where(status: Status.send(s.name)) }
    end

    def statuses
      Status
    end

    protected

    def change_status_to(status_name)
      transaction do
        before_update_status_hook
        self.update!(status: Status.send(status_name))
        after_update_status_hook
      end
    end

    # Template method
    def before_update_status_hook; end

    # Template method
    def after_update_status_hook; end

    def default_status
      Status.in_progress
    end

    def before_create_set_status
      self.status = default_status unless self.status
    end

    # It is only necessary for
    # passage_solutions with type a Quest.
    # todo: Where I can check it? 
    def already_verified!
      return unless unverified?
      errors.add(:status, 'already verified')
      ActiveRecord::RecordInvalid.new(self)
    end
  end
end
