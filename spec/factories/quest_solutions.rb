FactoryBot.define do
  factory :quest_solution do
    association :quest_passage
    sequence(:body) { |n| "QuestSolutionBody#{n}" }
    passed false
  end

  factory :invalid_quest_solution, class: QuestSolution do
    body nil
    passed false
  end
end
