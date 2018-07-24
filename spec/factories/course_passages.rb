FactoryBot.define do
  factory :course_passage do
    association :educable, factory: :user
    association :course
    passed false
  end
end
