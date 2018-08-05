class Course < ApplicationRecord
  include HtmlAttributable
  include Passable

  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  has_many :lessons, dependent: :destroy
  has_many :course_passages

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  validate :validate_author

  html_attributes :decoration_description

  # Passable Template method
  alias_attribute :passable_children, :lessons

  protected

  def validate_author
    unless author&.course_master?
      errors.add(:user, 'can\'t do this')
    end
  end
end
