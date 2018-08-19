class UserGrantable < ApplicationRecord
  belongs_to :user
  belongs_to :grantable, polymorphic: true
end
