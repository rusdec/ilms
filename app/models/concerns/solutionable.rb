module Solutionable
  extend ActiveSupport::Concern

  included do
    has_many :solutions, class_name: 'PassageSolution'

    def has_unverified_solutions?
      solutions.all_unverified.any?
    end
  end
end
