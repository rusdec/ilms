class QuestGroup < ApplicationRecord
  belongs_to :lesson
  has_many :quests
  has_many :quest_passages

  def destroy_if_empty
    destroy if empty?
  end

  def empty?
    quests.empty?
  end

  def siblings
    self.class.where('lesson_id = ? AND id != ?', lesson_id, id)
  end

  def self.create_quest_passages!(params)
    each do |quest_group|
      quest_group.quest_passages.create!(
        user: params[:user],
        lesson_passage: params[:lesson_passage]
      )
    end
  end
end
