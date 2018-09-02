require_relative 'models_helper'

RSpec.describe Lesson, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }

  it do
    should validate_numericality_of(:order)
      .only_integer
      .is_greater_than_or_equal_to(1)
  end

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
end
