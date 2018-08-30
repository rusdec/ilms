FactoryBot.define do
  factory :course_knowledge do
    association :course
    percent 100

    before(:create) do |course_knowledge|
      course_knowledge.knowledge ||= create(:knowledge)
    end
  end
end
