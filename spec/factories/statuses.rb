FactoryBot.define do
  factory :status do
    trait :in_progress do
      name :in_progress
    end
    trait :unverified do
      name :unverified
    end
    trait :accepted do
      name :accepted
    end
    trait :declined do
      name :declined
    end
  end
end
