class Lesson < ApplicationRecord
  has_closure_tree order: 'sort_order'

  include Persistable
  include Passable
  include Authorable
  include Difficultable

  belongs_to :course

  has_many :quests, dependent: :destroy
  has_many :quest_groups
  has_many :materials, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validate :validate_parent_lesson

  # Passable Template method
  alias_attribute :passable_children, :quests

  protected

  def validate_parent_lesson
    return if parent_id.nil?
    return if course.lessons.include?(Lesson.find_by(id: parent_id))
    errors.add(:parent, :invalid_id)
  end
end
