class Course < ApplicationRecord
  include Coursable
  include Passable
  include Authorable
  include Badgable

  has_many :lessons, dependent: :destroy
  has_many :badges, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  validate :validate_author

  # Passable Template method
  alias_attribute :passable_children, :lessons

  scope :all_published, -> { where(published: true) }

  # Coursable template method
  def course
    self
  end

  protected

  def validate_author
    unless author&.course_master?
      errors.add(:user, 'can\'t do this')
    end
  end
end
