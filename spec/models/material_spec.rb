require 'rails_helper'

RSpec.describe Material, type: :model do
  it { should belong_to(:author).with_foreign_key(:user_id).class_name('User') }
  it { should belong_to(:lesson) }

  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title)
      .is_at_least(3)
      .is_at_most(150)
  end

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }

  it do
    should validate_numericality_of(:order)
      .only_integer
      .is_greater_than_or_equal_to(1)
  end

  context 'default ordering' do
    let(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
    before do
      create(:material, lesson: lesson, author: lesson.author, order: 1)
    end

    it 'first material should have order 1' do
      expect(lesson.materials[0].order).to eq(1)
    end

    it 'last material should have order 5' do
      expect(lesson.materials[-1].order).to eq(5)
    end
  end
end
