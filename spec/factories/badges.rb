FactoryBot.define do
  factory :badge do
    association :author, factory: :course_master
    association :badgable, factory: :course
    association :course
    sequence(:title) { |n| "BadgeTitle#{n}"  }
    sequence(:description) { |n| "BadgeDescription#{n}" }
    image do
      Rack::Test::UploadedFile.new("#{Rails.root.join('spec/fixtures/image.png')}")
    end
  end

  factory :invalid_badge, class: Badge do
    title { nil }
  end
end
