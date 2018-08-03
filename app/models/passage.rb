class Passage < ApplicationRecord
  include Statusable

  has_closure_tree
  belongs_to :passable, polymorphic: true
  belongs_to :user

  validate :validate_passage_in_progress

  def self.in_progress?(passable)
    where(passable: passable, status: Status.find(:in_progress)).any?
  end

  protected

  def validate_passage_in_progress
    if self.class.find_by(user: user, passable: passable, status: Status.find(:in_progress))
      errors.add(passable.class.to_s.underscore.to_sym, 'in progress')
    end
  end
end
