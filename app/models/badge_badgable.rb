class BadgeBadgable < ApplicationRecord
  belongs_to :badgable, polymorphic: true
  belongs_to :badge
end
