require 'rails_helper'

RSpec.describe CourseKnowledge, type: :model do
  it { should belong_to(:course) }
  it { should belong_to(:knowledge) }
  it { should validate_presence_of(:percent) }
  it do
    should validate_numericality_of(:percent)
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(100)
  end
  it { should accept_nested_attributes_for(:knowledge).allow_destroy(false) }

  it do
    # Bug with validate_uniqueness_of and scoped_to
    # https://github.com/thoughtbot/shoulda-matchers/issues/682#issuecomment-187767983
    subject = create(:course_knowledge)
    is_expected.to validate_uniqueness_of(:knowledge_id)
      .scoped_to(:course_id)
      .with_message('should be once per course')
  end
  it { should have_db_index([:course_id, :knowledge_id]).unique }

  context '.experience_rate_from' do
    let(:course_knowledge) { create(:course_knowledge, percent: 80) }
    it 'returns 6,4' do
      expect(course_knowledge.experience_rate_from(8)).to eq(6.4)
    end
  end
end
