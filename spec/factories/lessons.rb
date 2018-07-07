FactoryBot.define do
  factory :lesson do
    sequence(:title) { |n| "LessonTitleText#{n}" }
    ideas 'LessonIdeas'
    summary 'LessonSummary'
    check_yourself 'LessonCheckQuestions'
  end

  factory :invalid_lesson, class: Lesson do
    title nil
  end
end
