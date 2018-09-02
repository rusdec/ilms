class QuestFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :difficulty, :description, :quest_group, :created_at, :updated_at
  attribute :quest_groups
end
