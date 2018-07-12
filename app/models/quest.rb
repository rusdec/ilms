class Quest < ApplicationRecord
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :lesson, optional: true

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 50 }

  validates :description, presence: true
  validates :description, length: { minimum: 10, maximum: 1000 }
  
  validates :level, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5 }

  scope :unused, -> { where(lesson_id: nil) }
  scope :used, -> { where.not(lesson_id: nil) }
  scope :unused_and_used_for, ->(lesson) { where('lesson_id IS NULL OR lesson_id=?', lesson) }

  # params = [{ id: integer, lesson_id: integer}]
  def self.update_lesson_id(params = nil, lesson_id = nil)
    return unless params
    quests = []
    params.each_pair { |index, param| quests << param[:id] if param[:lesson_id]}
    return if quests.empty?

    where(id: quests).update_all(lesson_id: lesson_id)
  end
end
