FactoryBot.define do
  factory :badge do
    sequence(:title) { |n| "BadgeTitle#{n}"  }
    sequence(:description) { |n| "BadgeDescription#{n}" }
  end

  factory :invalid_badge, class: Badge do
    title nil
  end
end
