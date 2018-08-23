class Quest < ApplicationRecord
  include Coursable
  include Passable
  include Authorable
  include Badgable

  belongs_to :lesson
  belongs_to :quest_group, optional: true
  belongs_to :old_quest_group, foreign_key: 'old_quest_group_id',
                               class_name: 'QuestGroup',
                               optional: true

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 50 }

  validates :description, presence: true
  validates :description, length: { minimum: 10, maximum: 500 }

  validates :body, html: { presence: true, length: { minimum: 10 } }
  
  validates :level, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5 } 

  before_create :before_create_set_quest_group

  before_update :before_update_create_new_quest_group_if_nil
  after_update :after_update_delete_old_quest_group_if_empty

  after_destroy :after_destroy_delete_quest_group_if_empty

  def alternatives
    self.class.where('quest_group_id = ? AND id != ?', quest_group_id, id)
  end

  def has_alternatives?
    !alternatives.empty?
  end

  # Coursable Tempalte method
  def course
    lesson.course
  end

  private

  def before_update_create_new_quest_group_if_nil
    self.quest_group = lesson.quest_groups.create! if quest_group.nil?
  end

  def after_update_delete_old_quest_group_if_empty
    if old_quest_group != quest_group
      old_quest_group.destroy_if_empty if old_quest_group
      self.old_quest_group = quest_group
      save
    end
  end

  def before_create_set_quest_group
    self.quest_group ||= lesson.quest_groups.create!
    self.old_quest_group = quest_group
  end

  def after_destroy_delete_quest_group_if_empty
    quest_group.destroy_if_empty if quest_group
  end
end
