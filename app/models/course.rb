class Course < ApplicationRecord
  include HtmlAttributable
  include Passable
  include Authorable

  has_many :lessons, dependent: :destroy

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
