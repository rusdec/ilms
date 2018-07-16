class Material < ApplicationRecord
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  belongs_to :lesson

  default_scope { order(:order) }

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 150 }

  validates :body, presence: true
  validates :body, length: { minimum: 10 }

  validates_numericality_of :order, { only_integer: true,
                                      greater_than_or_equal_to: 1 }
end
