FactoryBot.define do
  factory :user do
    sequence(:name)    { |n| "BotName#{n}" }
    sequence(:surname) { |n| "BotSurname#{n}" }
    sequence(:email)   { |n| "bot#{n}@email.org" }
    password 'password'

    trait :with_course do
      after(:create) { |user| create(:course, author: user) }
    end

    trait :with_courses do
      after(:create) { |user| create_list(:course, 5, author: user) }
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
        create_list(:quest, 5, course: user)
      end
    end
  end
end
