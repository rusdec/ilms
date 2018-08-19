require_relative 'models_helper'

RSpec.describe Badge, type: :model do
  it_behaves_like 'authorable'

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }
  it do
    should validate_length_of(:title)
      .is_at_least(3)
      .is_at_most(20)
  end

  it { should belong_to(:badgable) }
end
