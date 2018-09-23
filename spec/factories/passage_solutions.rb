FactoryBot.define do
  factory :passage_solution do
    association :passage
    sequence(:body) { |n| "PassageSolutionBody#{n}" }
  end

  factory :invalid_passage_solution, class: PassageSolution do
    body { nil }
    passed { false }
  end
end
