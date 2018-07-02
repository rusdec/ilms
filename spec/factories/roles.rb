FactoryBot.define do
  factory :role do
  end

  factory :role_user do
    name 'user'
  end

  factory :role_administrator do
    name 'administrator'
  end

  factory :role_course_master do
    name 'course_master'
  end
end
