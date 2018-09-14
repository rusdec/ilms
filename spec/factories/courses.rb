FactoryBot.define do
  factory :course do
    association :author, factory: :course_master
    sequence(:title) { |n| "CourseTitle#{n}" }
    sequence(:short_description) { |n| "CourseShortDescription#{n}" }
    published true
    difficulty 2
    course_knowledges_attributes {
      [attributes_for(:course_knowledge, knowledge: create(:knowledge))]
    }

    trait :full do
      after(:create) do |course|
        previous_lesson = nil
        1.upto(2) do
          previous_lesson = create(:lesson, :full,
            course: course,
            author: course.author,
            parent: previous_lesson            
          )
        end
      end
    end

    trait :unpublished do
      published false
    end

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

    trait :with_lessons_and_materials do
      after(:create) do |course|
        create_list(:lesson, :with_materials, course: course, author: course.author)
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
