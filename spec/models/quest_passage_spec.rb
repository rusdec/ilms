require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  let!(:course) { create(:course, :full) }
  let!(:passage) { create(:passage, passable: course) }
  let(:quest_passage) { QuestPassage.first }

  context '.default_status' do
    it 'should be in_progress' do
      expect(quest_passage.status). to eq(Status.in_progress)
    end
  end

  context '.ready_to_pass?' do
    let!(:passage_solution) { create(:passage_solution, passage: quest_passage) }

    context 'when has accepted solution' do
      before { passage_solution.accepted! }

      it 'should return true' do
        expect(quest_passage).to be_ready_to_pass
      end
    end

    context 'when has not accepted solution' do
      it 'should return false' do
        expect(quest_passage).to_not be_ready_to_pass
      end
    end
  end
end
