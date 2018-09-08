FactoryBot.define do
  factory :knowledge do
    sequence(:name) { |n| "KnowledgeName#{n}" }
    association :direction, factory: :knowledge_direction
  end
end
