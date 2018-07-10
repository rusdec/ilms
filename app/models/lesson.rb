class Lesson < ApplicationRecord
  has_closure_tree

  include Persistable

  has_many :quests, dependent: :destroy

  belongs_to :course
  belongs_to :author, foreign_key: :user_id, class_name: 'User'

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :order, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1 }
end
