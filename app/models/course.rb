class Course < ApplicationRecord
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  has_many :lessons

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  validate :validate_author

  protected

  def validate_author
    unless author&.course_master?
      errors.add(:user, 'can\'t do this')
    end
  end
end
