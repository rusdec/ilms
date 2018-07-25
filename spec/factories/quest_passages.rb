FactoryBot.define do
  factory :quest_passage do
    association :lesson_passage
    association :quest
    passed false
  end

  trait :with_solutions do
    after(:create) do |quest_passage|
      create(:quest_solution, quest_passage: quest_passage).decline!
      create(:quest_solution, quest_passage: quest_passage).accept!
      create(:quest_solution, quest_passage: quest_passage)
    end
  end
end
