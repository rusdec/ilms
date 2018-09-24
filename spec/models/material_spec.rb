require_relative 'models_helper'

RSpec.describe Material, type: :model do
  it { should belong_to(:lesson) }

  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title)
      .is_at_least(3)
      .is_at_most(150)
  end

  it_behaves_like 'authorable'

  context 'html validations' do
    let(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
    let(:material) { build(:material, lesson: lesson, author: lesson.author) }

    context 'validate length' do
      it 'body with 9 symbols should be invalid' do
        material.body = '<span>012345678</span>'
        expect(material).to_not be_valid
      end

      it 'body with 10 symbols should be valid' do
        material.body = '<span>0123456789</span>'
        expect(material).to be_valid
      end
    end

    context 'validate presence' do
      it 'body with spaces only should be invalid' do
        material.body = '<span>          </span>'
        expect(material).to_not be_valid
      end
    end
  end 

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
