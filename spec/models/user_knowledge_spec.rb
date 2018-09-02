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
    let(:user_knowledge) { create(:user_knowledge, experience: 0) }

    it 'sums up current experience with given' do
      user_knowledge.update(level: 10)
      user_knowledge.add_experience!(30)
      user_knowledge.reload
      expect(user_knowledge.experience).to be(30)
    end

    context 'when increases level' do
      it 'increases level' do
        user_knowledge.add_experience!(25)
        expect(user_knowledge.level).to eq(3)
      end
      
      it 'transfers remaining experience to new level' do
        user_knowledge.add_experience!(27)
        expect(user_knowledge.experience).to eq(2)
      end

      it 'not increases level if max level' do
        user_knowledge.update(level: user_knowledge.max_level)
        user_knowledge.add_experience!(user_knowledge.next_level_experience)
        expect(user_knowledge.level).to eq(user_knowledge.max_level)
      end

      it 'ddd' do
        user_knowledge.add_experience!(480)
      end
    end # context 'when increases level'
  end # context '.add_experience!'
end
