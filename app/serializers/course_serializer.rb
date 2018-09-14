class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :difficulty, :published, :user_id,
             :decoration_description, :created_at, :updated_at,
             :short_description, :image
  def image
    { original: object.image.present? ? object.image.url : nil,
      preview:  object.image.present? ? object.image.preview.url : nil }
  end
end
