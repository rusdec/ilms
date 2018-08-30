FactoryBot.define do
  factory :passage do
    association :user
    parent_id nil
  end

  factory :course_passage, class: CoursePassage do
    association :user
    parent_id nil
  end

  trait :with_solutions do
    after(:create) do |passage|
      solution = create(:passage_solution, passage: passage)
      solution.declined!
      create(:passage_solution, passage: passage)
    end
  end
end
