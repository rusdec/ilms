class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :level, :published, :user_id,
             :decoration_description, :created_at, :updated_at
end
