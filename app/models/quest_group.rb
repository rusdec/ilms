class QuestGroup < ApplicationRecord
  belongs_to :lesson
  has_many :quests

  def destroy_if_empty
    destroy if empty?
  end

  def empty?
    quests.empty?
  end

  def siblings
    self.class.where('lesson_id = ? AND id != ?', lesson_id, id)
  end
end
