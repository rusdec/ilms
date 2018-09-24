class BadgeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image

  def image
    { original: object.image.url, preview: object.image.preview.url }
  end
end
