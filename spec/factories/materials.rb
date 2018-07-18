FactoryBot.define do
  factory :material do
    sequence(:title) { |n| "MaterialTitle#{n}" }
    sequence(:body) { |n| "MaterialBody#{n}" }
    sequence(:summary) { |n| "MaterialSequence#{n}" }
    order 1

    factory :material_high_order do
      order 9999
    end
  end

  factory :invalid_material, class: Material do
    title nil
    body nil
    summary nil
  end
end
