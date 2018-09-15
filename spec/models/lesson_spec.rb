require_relative 'models_helper'

RSpec.describe Lesson, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }

  it { should belong_to(:course) }

  it { should have_many(:quests).dependent(:destroy) }
  it { should have_many(:quest_groups) }

  it { should have_many(:materials).dependent(:destroy) }

  it { should be_a_closure_tree }
  it_should_behave_like 'persistable', Lesson.all

  it_behaves_like 'passable'
  it_behaves_like 'authorable'
  it_behaves_like 'difficultable'

  it '.passable_children' do
    lesson = create(:lesson, :with_quests)
    expect(lesson.passable_children).to eq(lesson.quests)
  end

  context 'validates parent lesson' do
    let!(:lesson) { create(:lesson) }

    context 'when lesson\'s course not include given lesson ' do
      it 'validation returns error' do
        new_lesson = build(:lesson, course: create(:course), parent: lesson)
        new_lesson.validate
        expect(new_lesson.errors.full_messages).to eq(['Opening lesson is invalid'])
      end
    end

    context 'when lesson is not find' do
      it 'validation returns error' do
        new_lesson = build(:lesson, course: create(:course), parent_id: 21)
        new_lesson.validate
        expect(new_lesson.errors.full_messages).to eq(['Opening lesson is invalid'])
      end
    end

    context 'when lesson\'s course include given lesson ' do
      it 'not creates error' do
        new_lesson = build(:lesson, course: lesson.course, parent: lesson)
        expect(new_lesson).to be_valid
      end
    end

    context 'when given lesson is nil' do
      it 'not creates error' do
        new_lesson = build(:lesson, course: create(:course), parent: nil)
        expect(new_lesson).to be_valid
      end
    end
  end
end
