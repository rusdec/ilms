class QuestFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :level, :description, :quest_group, :created_at, :updated_at
  attribute :quest_groups
end
