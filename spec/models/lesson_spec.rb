require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should belong_to(:course) }
  it { should belong_to(:author).with_foreign_key('user_id').class_name('User') }
  it do
    should validate_numericality_of(:order)
      .only_integer
      .is_greater_than_or_equal_to(1)
  end
end
