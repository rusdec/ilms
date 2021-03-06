FactoryBot.define do
  factory :lesson do
    association :author, factory: :course_master
    association :course
    sequence(:title) { |n| "LessonTitleText#{n}" }
    ideas { 'LessonIdeas' }
    summary { 'LessonSummary' }
    check_yourself { 'LessonCheckQuestions' }
    difficulty { 2 }

    trait :full do
      after(:create) do |lesson|
        1.upto(2) do |n|
          create(:material, lesson: lesson, order: n, author: lesson.author)
        end
        quests = create_list(:quest, 3, lesson: lesson, author: lesson.author)
        quests[0].update(quest_group: quests[1].quest_group)
      end
    end

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
    title { nil }
  end
end
