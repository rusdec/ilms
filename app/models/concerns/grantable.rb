module Grantable
  extend ActiveSupport::Concern

  included do
    has_many :user_grantables, as: :grantable, dependent: :destroy
    has_many :rewarders, through: :user_grantables, source: :user
  end
end
