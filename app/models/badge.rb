class Badge < ApplicationRecord
  include Authorable

  has_many :badge_badgables
  has_many :badgable, through: :badge_badgables

  has_many :user_badges
  has_many :users, through: :user_badges

  has_one_attached :image

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 20 }
end
