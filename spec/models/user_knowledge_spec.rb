require 'rails_helper'

RSpec.describe UserKnowledge, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:knowledge) }

  it do
    # Bug with validate_uniqueness_of and scoped_to
    # https://github.com/thoughtbot/shoulda-matchers/issues/682#issuecomment-187767983
    subject = create(:user_knowledge)
    is_expected.to validate_uniqueness_of(:knowledge_id)
      .scoped_to(:user_id)
      .with_message('should be once per user')
  end

  it { should have_db_index([:user_id, :knowledge_id]).unique }

  it do
    should validate_numericality_of(:level)
      .is_greater_than_or_equal_to(0)
      .only_integer
  end

  it do
    should validate_numericality_of(:experience)
      .is_greater_than_or_equal_to(0)
      .only_integer
  end

  context '.add_experience!' do
    let(:user_knowledge) { create(:user_knowledge, experience: 100) }

    it 'sums up current experience with given' do
      user_knowledge.add_experience!(30)
      user_knowledge.reload
      expect(user_knowledge.experience).to be(130)
    end
  end
end
