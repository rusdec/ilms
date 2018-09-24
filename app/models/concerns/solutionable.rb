module Solutionable
  extend ActiveSupport::Concern

  included do
    has_many :solutions, class_name: 'PassageSolution', dependent: :destroy

    def has_unverified_solutions?
      solutions.all_unverified.any?
    end

    protected

    def validate_unverification_solutions
      if passage.has_unverified_solutions?
        errors.add(:quest_solution, 'already created')
      end
    end
  end
end
