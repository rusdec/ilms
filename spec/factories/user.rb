FactoryBot.define do
  factory :user do
    sequence(:name)    { |n| "BotName#{n}" }
    sequence(:surname) { |n| "BotSurname#{n}" }
    sequence(:email)   { |n| "bot#{n}@email.org" }
    password 'password'

    factory :administrator do
      type 'Administrator'
    end

    factory :course_master do
      type 'CourseMaster'
    end
  end
end
