class UserKnowledge < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :knowledge

  validates :knowledge_id, uniqueness: { scope: :user_id,
                                         message: 'should be once per user' }
  validates :level, numericality: { greater_than_or_equal_to: 0,
                                    only_integer: true }
  validates :experience, numericality: { greater_than_or_equal_to: 0,
                                         only_integer: true }

  def self.by_directions
    knowledges = {}
    all.each do |user_knowledge|
      direction = if user_knowledge.knowledge.direction
                    user_knowledge.knowledge.direction.name
                  else
                    'Other'
                  end
      knowledges[direction] ||= []
      knowledges[direction] << user_knowledge
    end
    knowledges
  end

  def add_experience!(value = 0)
    transaction do
      update!(experience: experience + value)
      level_up!
    end
  end

  def next_level_experience
    ((level + 1) * (multiplier - (level/max_level.to_f))).round
  end

  def remaining_experience
    next_level_experience - experience
  end

  def max_level
    100
  end

  protected

  def level_up!
    return if max_level?
    return unless level_up?

    update!(level: level + 1, experience: remaining_experience.abs)
    level_up!
  end

  def max_level?
    level >= max_level
  end

  def level_up?
    remaining_experience <= 0
  end

  def multiplier
    5
  end
end
