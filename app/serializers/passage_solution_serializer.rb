class PassageSolutionSerializer < ActiveModel::Serializer
  attributes :id, :passage_id, :body, :created_at, :updated_at, :status
end
