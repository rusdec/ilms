class Lesson < ApplicationRecord
  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  belongs_to :course
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
end
