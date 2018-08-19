require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  let!(:course) { create(:course, :full) }
  let!(:passage) { create(:passage, passable: course) }
  let(:quest_passage) { QuestPassage.first }

  context '.can_be_in_progress?' do
    it 'returns true' do
      expect(quest_passage).to be_can_be_in_progress
    end
  end

  context '.default_status' do
    it 'returns Status in_progress' do
      expect(quest_passage.status). to eq(Status.in_progress)
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

  context '.after_pass_hook' do
    let(:user) { quest_passage.user }

    context 'when passable (quest) have badge' do
      before do
        create(:badge, badgable: quest_passage.passable)
        allow(quest_passage).to receive(:ready_to_pass?).and_return(true)
      end

      it 'user receives reward! with badge' do
        expect(user).to receive(:reward!).with(quest_passage.passable.badge)
        quest_passage.try_chain_pass!
      end
    end

    context 'when passable (quest) have not badge' do
      it 'user does not receives reward!' do
        expect(user).to_not receive(:reward!)
        quest_passage.try_chain_pass!
      end
    end
  end # context '.after_pass_hook'
end
