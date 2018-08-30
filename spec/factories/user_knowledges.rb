FactoryBot.define do
  factory :user_knowledge do
    association :user
    before(:create) do |course_knowledge|
      course_knowledge.knowledge ||= create(:knowledge)
    end
  end
end
