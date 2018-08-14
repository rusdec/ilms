FactoryBot.define do
  factory :lesson_passage do
    association :user
    parent_id nil
  end
end
