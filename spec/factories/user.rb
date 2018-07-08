FactoryBot.define do
  factory :user do
    sequence(:name)    { |n| "BotName#{n}" }
    sequence(:surname) { |n| "BotSurname#{n}" }
    sequence(:email)   { |n| "bot#{n}@email.org" }
    password 'password'

    factory :administrator, class: Administrator do
      type 'Administrator'
    end

    factory :course_master, class: CourseMaster do
      type 'CourseMaster'
    end
  end
end
