FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "CourseTitle#{n}" }
    association :author, factory: :course_master

    trait :with_lesson do
      after(:create) do |course|
        create(:lesson, course: course, author: course.author)
      end
    end

    trait :with_lessons do
      after(:create) do |course|
        previous_lesson = nil
        1.upto(5) do
          previous_lesson = create(:lesson,
            course: course,
            author: course.author,
            parent: previous_lesson            
          )
        end
      end
    end

    trait :with_lesson_and_quest do
      after(:create) do |course|
        create(:lesson, :with_quest, course: course, author: course.author)
      end
    end
  end

  factory :invalid_course, class: Course do
    title nil
  end
end
