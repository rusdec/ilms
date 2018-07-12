class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :level, :created_at, :updated_at
end
