FactoryBot.define do
  factory :lesson do
    sequence(:title) { |n| "LessonTitleText#{n}" }
    ideas 'LessonIdeas'
    summary 'LessonSummary'
    check_yourself 'LessonCheckQuestions'

    trait :with_quest do
      after(:create) do |lesson|
        create(:quest, :with_quest_group, lesson: lesson, author: lesson.author)
      end
    end

    after(:create) do |lesson|
      create_list(:material, 5, lesson: lesson, author: lesson.author)
    end
  end

  factory :invalid_lesson, class: Lesson do
    title nil
  end
end
