class Badge < ApplicationRecord
  include Authorable

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
  validates :title, length: { minimum: 3, maximum: 20 }
end
