FactoryBot.define do
  factory :user_knowledge do
    association :user
    sequence(:level) { rand(100) }
    before(:create) do |course_knowledge|
      course_knowledge.knowledge ||= create(:knowledge)
    end
  end
end
