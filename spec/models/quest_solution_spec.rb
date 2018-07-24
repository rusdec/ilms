require_relative 'models_helper'

RSpec.describe QuestSolution, type: :model do
  it { should belong_to(:quest_passage) }

  let(:html_validable) do
    { field: :body, object: create(:quest_solution) }
  end
  it_behaves_like 'html_presence_validable'

  it_behaves_like 'html_attributable', %i(body)

  context '.accept!' do
    let!(:quest_solution) { create(:quest_solution) }

    it 'solution should be passed' do
      quest_solution.accept!
      quest_solution.reload
      expect(quest_solution).to be_passed
    end

    it 'solution receive verify!' do
      expect(quest_solution).to receive(:verify!)
      quest_solution.accept!
    end
  end

  context 'decline!' do
    let!(:quest_solution) { create(:quest_solution) }

    it 'solution should not be passed' do
      quest_solution.decline!
      quest_solution.reload
      expect(quest_solution).to_not be_passed
    end

    it 'solution receive verify!' do
      expect(quest_solution).to receive(:verify!)
      quest_solution.decline!
    end
  end

  context '.verify!' do
    let!(:quest_solution) { create(:quest_solution) }
    
    it 'verified return true' do
      expect(quest_solution).to receive(:update!).with(verified: true)
      quest_solution.send :verify!
    end
  end

  it '#for_auditor' do
    solutions = create(:quest_passage, :with_solutions).quest_solutions
    user = solutions.last.quest_passage.quest.author
    create_list(:quest_solution, 3)

    expect(
      QuestSolution.for_auditor(user).order(:created_at)
    ).to eq(solutions.order(:created_at))
  end

  it '#unverifieds_for_auditor' do
    solutions = create(:quest_passage, :with_solutions).quest_solutions
    user = solutions.last.quest_passage.quest.author
    solutions.last.decline!

    expect(
      QuestSolution.unverifieds_for_auditor(user)
    ).to_not include(solutions.last)
  end
end
