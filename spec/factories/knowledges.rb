FactoryBot.define do
  factory :knowledge do
    sequence(:name) { |n| "KnowledgeName#{n}" }
  end
end
