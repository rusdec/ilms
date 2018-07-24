FactoryBot.define do
  factory :quest_passage do
    association :lesson_passage
    association :quest
    passed false
  end

  trait :with_solutions do
    after(:create) do |quest_passage|
      create_list(:quest_solution, 3, quest_passage: quest_passage)
    end
  end
end
