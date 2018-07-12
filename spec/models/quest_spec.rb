require 'rails_helper'

RSpec.describe Quest, type: :model do
  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title).is_at_least(3).is_at_most(50)
  end

  it { should validate_presence_of(:description) }
  it do
    should validate_length_of(:description).is_at_least(10).is_at_most(1000)
  end

  it do
    should validate_numericality_of(:level)
      .only_integer
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(5)
  end

  it { should belong_to(:author).with_foreign_key('user_id').class_name('User') }
  it { should belong_to(:lesson) }

  it '#unused' do
    user = create(:course_master, :with_quests)
    lesson = create(:course, :with_lesson, author: user).lessons.last
    
    lesson.quests << user.quests.last
    expect(user.quests.unused.count).to eq(4)
  end

  it '#used' do
    user = create(:course_master, :with_quests)
    lesson = create(:course, :with_lesson, author: user).lessons.last
    
    lesson.quests << user.quests.last
    expect(user.quests.used.count).to eq(1)
  end
end
