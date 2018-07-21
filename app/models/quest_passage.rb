class QuestPassage < ApplicationRecord
  belongs_to :quest_group
  belongs_to :lesson_passage
end
