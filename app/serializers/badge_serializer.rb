class BadgeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image

  def image
    object.image.service_url if object.image.attached?
  end
end
