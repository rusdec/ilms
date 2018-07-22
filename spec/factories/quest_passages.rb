FactoryBot.define do
  factory :quest_passage do
    association :lesson_passage
    association :quest
    passed false
  end
end
