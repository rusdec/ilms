FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "CourseTitle#{n}" }
  end

  factory :invalid_course, class: Course do
    title nil
  end
end
