class Course < ApplicationRecord
  include Passable
  include Authorable
  include Badgable
  include CourseKnowledgable
  include Difficultable

  paginates_per 5

  has_many :lessons, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :quests, through: :lessons
  has_many :course_knowledges, dependent: :destroy, inverse_of: :course
  has_many :knowledges, through: :course_knowledges

  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :course_knowledges,
                                reject_if: proc { |ck| ck[:percent].to_i <= 0 },
                                allow_destroy: true


  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :short_description, length: { maximum: 350 }

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
