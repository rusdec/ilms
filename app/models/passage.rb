class Passage < ApplicationRecord
  include Statusable

  has_closure_tree dependent: :destroy
  belongs_to :passable, polymorphic: true
  belongs_to :user

  validate :validate_passage_in_progress

  after_create :after_create_hook_create_children

  def self.in_progress?(passable)
    where(passable: passable, status: Status.find(:in_progress)).any?
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
    if self.class.find_by(user: user, passable: passable, status: Status.find(:in_progress))
      errors.add(passable.class.to_s.underscore.to_sym, 'in progress')
    end
  end
end
