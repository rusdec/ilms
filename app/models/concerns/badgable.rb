module Badgable
  extend ActiveSupport::Concern

  included do
    has_one :badge_badgable, as: :badgable
    has_one :badge, through: :badge_badgable
  end
end
