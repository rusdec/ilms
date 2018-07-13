FactoryBot.define do
  factory :lesson do
    sequence(:title) { |n| "LessonTitleText#{n}" }
    ideas 'LessonIdeas'
    summary 'LessonSummary'
    check_yourself 'LessonCheckQuestions'

    trait :with_quest do
      after(:create) do |lesson|
        create(:quest, lesson: lesson, author: lesson.author)
      end
    end
  end

  factory :invalid_lesson, class: Lesson do
    title nil
  end
end
