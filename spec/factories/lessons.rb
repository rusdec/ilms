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

    trait :with_quests do
      after(:create) do |lesson|
        create_list(:quest, 5, lesson: lesson, author: lesson.author)
      end
    end

    after(:create) do |lesson|
      1.upto(5) do |n|
        create(:material, lesson: lesson, author: lesson.author, order: n)
      end
    end
  end

  factory :invalid_lesson, class: Lesson do
    title nil
  end
end
