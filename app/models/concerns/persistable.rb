module Persistable
  extend ActiveSupport::Concern

  included do
    scope :persisted, -> { where.not(id: nil) }
  end
end
