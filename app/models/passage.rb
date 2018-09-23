class Passage < ApplicationRecord
  include Statusable
  include Solutionable

  after_create :after_create_hook_create_children
  before_create :before_create_hook_set_type

  has_closure_tree dependent: :destroy
  belongs_to :passable, polymorphic: true
  belongs_to :user

  validate :validate_passage_in_progress, on: :create

  scope :by_type, ->(type) { where(passable_type: type) }
  scope :for_courses, -> { by_type('Course') }
  scope :for_lessons, -> { by_type('Lesson') }
  scope :for_quests,  -> { by_type('Quest') }

  default_scope { order(:created_at) }

  def self.in_progress?(passable)
    where(passable: passable, status: :in_progress).any?
  end

  def try_chain_pass!
    return if passed?
    return unless ready_to_pass?

    transaction do
      passed!
      after_pass_hook
      parent&.try_chain_pass!
    end
  end

  # Template method
  def can_be_in_progress?
    false
  end

  protected

  # Template method
  def ready_to_pass?; end

  # Template method
  def after_pass_hook; end

  def before_create_hook_set_type
    self.type = "#{passable.class}Passage"
  end

  def after_create_hook_create_children
    transaction do
      passable.passable_children.each do |child|
        # todo: move to subclasses
        "#{child.class}Passage".constantize.create!(
          passable: child,
          user: self.user,
          parent: self
        )
      end
    end
  end

  def validate_passage_in_progress
    return if can_be_in_progress?
    if self.class.find_by(user: user, passable: passable, status: :in_progress)
      errors.add(passable.class.to_s.underscore.to_sym, 'in progress')
    end
  end
end
