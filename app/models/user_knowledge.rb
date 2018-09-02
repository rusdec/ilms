class UserKnowledge < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :knowledge

  validates :knowledge_id, uniqueness: { scope: :user_id,
                                         message: 'should be once per user' }
  validates :level, numericality: { greater_than_or_equal_to: 0,
                                    only_integer: true }
  validates :experience, numericality: { greater_than_or_equal_to: 0,
                                         only_integer: true }

  def max_level
    100
  end

  def miltiplier
    5
  end

  def add_experience!(value = 0)
    update!(experience: experience + value)
  end
end
