FactoryBot.define do
  factory :passage do
    association :user
    parent_id nil
  end
end
