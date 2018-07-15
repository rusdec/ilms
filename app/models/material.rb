class Material < ApplicationRecord
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  belongs_to :lesson

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
end
