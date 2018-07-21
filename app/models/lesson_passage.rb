class LessonPassage < ApplicationRecord
  belongs_to :lesson
  belongs_to :educable, polymorphic: true
  belongs_to :course_passage
  has_many :quest_passages, dependent: :destroy

  after_create :create_quest_passages

  private

  def create_quest_passages
    transaction do
      lesson.quest_groups.each do |quest_group|
        quest_passages.create!(quest_group: quest_group)
      end
    end
  end
end
