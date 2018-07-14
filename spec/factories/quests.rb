FactoryBot.define do
  factory :quest do
    sequence(:title) { |n| "QuestsTitle#{n}" }
    sequence(:description) { |n| "QuestsDescription#{n}" }
    level 1

    trait :with_quest_group do
      before(:create) do |quest|
        quest.quest_group = create(:quest_group, lesson: quest.lesson)
      end
    end
  end

  factory :invalid_quest, class: Quest do
    title nil
    description nil
  end

  factory :updated_quest, class: Quest do
    title 'NewQuestTitle'
    description 'NewQuestDescription'
  end
end
