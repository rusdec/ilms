FactoryBot.define do
  factory :lesson_passage do
    association :educable, factory: :user
    association :course_passage
    association :lesson
    passed false
  end
end
