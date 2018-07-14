class Quest < ApplicationRecord
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :lesson
  belongs_to :quest_group, optional: true

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 50 }

  validates :description, presence: true
  validates :description, length: { minimum: 10, maximum: 1000 }
  
  validates :level, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5 } 

  def alternatives
    self.class.where('quest_group_id = ? AND id != ?', quest_group_id, id)
  end

  def has_alternatives?
    !alternatives.empty?
  end
end
