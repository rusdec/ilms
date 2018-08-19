module Rewardable
  extend ActiveSupport::Concern

  included do
    has_many :user_grantables, dependent: :destroy
    has_many :badges, through: :user_grantables, source: :grantable, source_type: 'Badge'

    def reward!(grantable)
      user_grantables.create(grantable: grantable)
    end
  end
end
