class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty, :created_at, :updated_at
end
