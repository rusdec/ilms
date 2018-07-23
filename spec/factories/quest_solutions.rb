FactoryBot.define do
  factory :quest_solution do
    association :quest_passage
    sequence(:body) { |n| "QuestSolutionBody#{n}" }
    passed false
    verified false

    factory :decline_solution do
      verified true
    end

    factory :accepted_solution do
      passed true
      verified true
    end
  end

  factory :invalid_quest_solution, class: QuestSolution do
    body nil
    passed false
  end
end
