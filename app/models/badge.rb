class Badge < ApplicationRecord
  include Authorable
  include Grantable

  mount_uploader :image, ImageUploader

  belongs_to :badgable, polymorphic: true
  belongs_to :course

  validates :title, presence: true
  validates :image, presence: true
  validates :title, length: { minimum: 3, maximum: 35 }

  scope :hiddens, -> { where(hidden: true) }
end
