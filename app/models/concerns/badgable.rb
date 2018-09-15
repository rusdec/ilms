module Badgable
  extend ActiveSupport::Concern

  included do
    has_one :badge, as: :badgable, dependent: :destroy
  end
end
