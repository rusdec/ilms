module Statusable
  extend ActiveSupport::Concern

  included do
    before_create :before_create_set_status
    before_update :set_change_status, if: :will_save_change_to_status?
    after_update :after_update_status

    enum status: {
      in_progress: 0,
      passed: 1,
      failed: 2,
      accepted: 3,
      declined: 4,
      unverified: 5,
      unavailable: 6
    }

    def statuses
      self.class.statuses
    end

    statuses.each do |status, id|
      scope "all_#{status}", -> { where(status: status) }
    end
    
    protected

    def set_change_status
      @was_saved_change_to_status = true
    end

    def was_saved_change_to_status?
      @was_saved_change_to_status
    end

    def after_update_status
      if @was_saved_change_to_status
        after_update_status_hook
        @was_saved_change_to_status = false
      end
    end

    # Template method
    def after_update_status_hook; end

    # Template method
    def default_status
      :in_progress
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
