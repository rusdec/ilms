module Difficultable
  extend ActiveSupport::Concern

  included do
    validates :difficulty, presence: true
    validates :difficulty, numericality: { only_integer: true,
                                           greater_than_or_equal_to: 1,
                                           less_than_or_equal_to: 5 }
  end
end
