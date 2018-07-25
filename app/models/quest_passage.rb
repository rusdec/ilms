class QuestPassage < ApplicationRecord
  belongs_to :lesson_passage
  belongs_to :quest
  has_many :quest_solutions, dependent: :destroy

  def has_unverified_solutions?
    quest_solutions.unverified.any?
  end
end
