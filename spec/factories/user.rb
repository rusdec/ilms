FactoryBot.define do
  factory :user do
    sequence(:name)    { |n| "BotName#{n}" }
    sequence(:surname) { |n| "BotSurname#{n}" }
    sequence(:email)   { |n| "bot#{n}@email.org" }
    password 'password'

    trait :with_full_course do
      after(:create) do |user|
        course = create(:course, :full, author: user)
        create(:course_passage, educable: user, course: course)
      end
    end

    trait :with_course do
      after(:create) { |user| create(:course, author: user) }
    end

    trait :with_courses do
      after(:create) { |user| create_list(:course, 5, author: user) }
    end

    trait :with_course_and_lesson do
      after(:create) { |user| create(:course, :with_lesson, author: user) }
    end

    trait :with_course_and_lessons do
      after(:create) { |user| create(:course, :with_lessons, author: user) }
    end

    trait :with_course_and_lesson_and_quest do
      after(:create) { |user| create(:course, :with_lesson_and_quest, author: user) }
    end

    factory :administrator, class: Administrator do
      type 'Administrator'
    end

    factory :course_master, class: CourseMaster do
      type 'CourseMaster'
    end

    trait :with_quest do
      after(:create) do |user|
        create(:quest, author: user)
      end
    end

    trait :with_quests do
      after(:create) do |user|
        create_list(:quest, 5, author: user)
      end
    end
  end
end
