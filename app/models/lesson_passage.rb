class LessonPassage < ApplicationRecord
  belongs_to :lesson
  belongs_to :educable, polymorphic: true
  belongs_to :course_passage
  has_many :quest_passages, dependent: :destroy

  after_create :create_quest_passages

  def quest_passages_by_quest_group
    lesson.quest_groups.collect do |quest_group|
      quest_passages.where(quest: quest_group.quests)
    end
  end

  private

  def create_quest_passages
    transaction do
      quests = Quest.where(quest_group_id: lesson.quest_groups.pluck(:id))
      quests.each { |quest| quest_passages.create!(quest: quest) }
    end
  end
end
