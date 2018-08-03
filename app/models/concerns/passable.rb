module Passable
  extend ActiveSupport::Concern

  included do
    has_many :passages, as: :passable, dependent: :destroy
  end
end
