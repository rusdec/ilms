require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  let(:quest_passage) { create(:quest_passage, passable: create(:quest)) }
  before { allow(quest_passage).to receive(:destribute_experience_between_knowledges) }

  it { should belong_to(:quest).with_foreign_key(:passable_id) }

  it_behaves_like 'after_pass_hook_badge_grantable' do
    let(:passage) { quest_passage }
  end

  it 'receive .destribute_experience_between_knowledges after pass' do
    allow(quest_passage).to receive(:ready_to_pass?) { true }
    expect(quest_passage).to receive(:destribute_experience_between_knowledges)
    quest_passage.try_chain_pass!
  end

  it { should belong_to(:quest).with_foreign_key(:passable_id) }

  context '.can_be_in_progress?' do
    it 'returns true' do
      expect(quest_passage).to be_can_be_in_progress
    end
  end

  context '.open' do
    it 'receives in_progress!' do
      expect(quest_passage).to receive(:in_progress!)
      quest_passage.open!
    end
  end

  context '.default_status' do
    it 'returns Status unavailable' do
      expect(quest_passage.status). to eq('unavailable')
    end
  end

  context '.ready_to_pass?' do
    let!(:passage_solution) { create(:passage_solution, passage: quest_passage) }

    context 'when has accepted solution' do
      before { passage_solution.accepted! }

      it 'returns true' do
        expect(quest_passage).to be_ready_to_pass
      end
    end

    context 'when has not accepted solution' do
      it 'returns false' do
        expect(quest_passage).to_not be_ready_to_pass
      end
    end
  end # context '.ready_to_pass?'
end
