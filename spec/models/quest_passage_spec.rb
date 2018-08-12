require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  let!(:course) { create(:course, :full) }
  let!(:passage) { create(:passage, passable: course) }
  let(:quest_passage) { QuestPassage.first }
  let!(:passage_solution) { create(:passage_solution, passage: quest_passage) }

  context '.ready_to_pass?' do
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
