module CourseKnowledgable
  extend ActiveSupport::Concern

  included do
    validate :validate_percent

    def free_knowledges
      Knowledge.where.not(id: knowledges.pluck(:id))
    end

    def new_knowledges_for_user(user)
    end

    protected

    def validate_percent
      percent = course_knowledges.reject(&:marked_for_destruction?).sum { |ck| ck[:percent] }
      errors.add(:percent, "of course knowledges must be 100% now #{percent}%") if percent != 100
    end
  end
end
