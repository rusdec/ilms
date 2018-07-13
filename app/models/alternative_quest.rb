class AlternativeQuest < ApplicationRecord
  belongs_to :quest
  belongs_to :alternative_quest, class_name: 'Quest'

  validate :validate_refer_to_himself

  private

  def validate_refer_to_himself
    if quest_id == alternative_quest_id
      errors.add(:quest, "can\'t refer to himself")
    end
  end
end
