FactoryBot.define do
  factory :status do
    trait :in_progress do
      id :in_progress
    end
    trait :unverified do
      id :unverified
    end
    trait :accepted do
      id :accepted
    end
    trait :declined do
      id :declined
    end
  end
end
