FactoryBot.define do
  factory :quest do
    association :author, factory: :course_master
    association :lesson
    sequence(:title) { |n| "QuestsTitle#{n}" }
    sequence(:description) { |n| "QuestsDescription#{n}" }
    sequence(:body) { |n| "ValidQuestBody#{n}" }
    difficulty { 3 }
  end

  factory :invalid_quest, class: Quest do
    title { nil }
    description { nil }
  end

  factory :updated_quest, class: Quest do
    title { 'NewQuestTitle' }
    body { 'ValidQuestBody' }
    description { 'NewQuestDescription' }
  end
end
