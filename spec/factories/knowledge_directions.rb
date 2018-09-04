FactoryBot.define do
  factory :knowledge_direction do
    sequence(:name) { |n| "Direction#{n}" }

    trait :invalid do
      name nil
    end
  end
end
