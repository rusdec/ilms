class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :decoration_description, :level, :updated_at
end
