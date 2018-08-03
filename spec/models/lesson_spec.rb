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
  it { should belong_to(:author).with_foreign_key('user_id').class_name('User') }

  it { should have_many(:quests).dependent(:destroy) }
  it { should have_many(:quest_groups) }

  it { should have_many(:lesson_passages) }

  it { should have_many(:materials).dependent(:destroy) }

  it { should be_a_closure_tree }
  it_should_behave_like 'persistable', Lesson.all

  it_behaves_like 'html_attributable', %w(ideas summary check_yourself)
end
