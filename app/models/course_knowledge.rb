class CourseKnowledge < ApplicationRecord
  belongs_to :course
  belongs_to :knowledge

  accepts_nested_attributes_for :knowledge, reject_if: :all_blank

  validates :percent, presence: true
  validates :percent, numericality: { greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 100 }

  validates :knowledge_id, uniqueness: { scope: :course_id,
                                      message: 'should be once per course' }

  def experience_rate_from(value = 0)
    value * (percent/100.0)
  end
end
