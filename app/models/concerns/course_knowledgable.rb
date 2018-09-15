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
      if percent != 100
        errors.add(
          :total_percent_of_knowledges,
          I18n.t('concerns.course_knowledgable.must_equal_100_percent', percent: percent)
        )
      end
    end
  end
end
