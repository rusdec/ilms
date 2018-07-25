require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  it { should belong_to(:lesson_passage) }
  it { should belong_to(:quest) }
  it { should have_many(:quest_solutions).dependent(:destroy) }

  context '.have_unverified_solutions?' do
    let!(:quest_solution) { create(:quest_solution) }
    let(:quest_passage) { quest_solution.quest_passage }

    context 'when unverified solutions exist' do
      it 'should return true' do
        expect(quest_passage).to have_unverified_solutions
      end
    end

    context 'when unverified solutions not exist' do
      before { quest_passage.quest_solutions.each(&:accept!) }

      it 'should return false' do
        expect(quest_passage).to_not have_unverified_solutions
      end
    end
  end
end
