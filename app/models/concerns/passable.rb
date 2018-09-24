module Passable
  extend ActiveSupport::Concern

  included do
    has_many :passages, as: :passable, dependent: :destroy

    # Template method
    def passable_children
      []
    end
  end
end
