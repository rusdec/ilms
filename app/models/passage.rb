class Passage < ApplicationRecord
  include Statusable
  include Solutionable

  after_create :after_create_hook_create_children

  has_closure_tree dependent: :destroy
  belongs_to :passable, polymorphic: true
  belongs_to :user

  validate :validate_passage_in_progress, on: :create

  scope :by_type, ->(type) { where(passable_type: type) }
  scope :for_courses, ->() { by_type('Course') }
  scope :for_lessons, ->() { by_type('Lesson') }
  scope :for_quests,  ->() { by_type('Quest') }

  def self.in_progress?(passable)
    where(passable: passable, status: Status.in_progress).any?
  end

  protected

  def after_create_hook_create_children
    transaction do
      passable.passable_children.each do |passable_child|
        children.create!(passable: passable_child, user: self.user)
      end
    end
  end

  def validate_passage_in_progress
    if self.class.find_by(user: user, passable: passable, status: Status.in_progress)
      errors.add(passable.class.to_s.underscore.to_sym, 'in progress')
    end
  end
end
