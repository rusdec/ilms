FactoryBot.define do
  factory :passage do
    association :user
    parent_id { nil }
  end

  factory :course_passage, class: CoursePassage do
    association :passable, factory: :course
    association :user
    parent_id { nil }
  end

  factory :lesson_passage, class: LessonPassage do
    association :passable, factory: :lesson
    association :user
    parent_id { nil }
  end

  factory :quest_passage, class: QuestPassage do
    association :passable, factory: :quest
    association :user
    parent_id { nil }
  end

  trait :with_solutions do
    after(:create) do |passage|
      solution = create(:passage_solution, passage: passage)
      solution.declined!
      create(:passage_solution, passage: passage)
    end
  end
end
