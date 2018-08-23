class Course < ApplicationRecord
  include Passable
  include Authorable
  include Badgable

  has_many :lessons, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :quests, through: :lessons

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  validate :validate_author

  # Passable Template method
  alias_attribute :passable_children, :lessons

  alias_attribute :course, :itself

  scope :all_published, -> { where(published: true) }

  protected

  def validate_author
    unless author&.course_master?
      errors.add(:user, 'can\'t do this')
    end
  end
end
