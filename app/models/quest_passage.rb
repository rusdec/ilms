class QuestPassage < ApplicationRecord
  belongs_to :lesson_passage
  belongs_to :quest
end
