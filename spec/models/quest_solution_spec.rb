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

    it 'solution receive verify!' do
      expect(quest_solution).to receive(:verify!).with(true)
      quest_solution.accept!
    end
  end # context '.accept!'

  context '.decline!' do
    let!(:quest_solution) { create(:quest_solution) }

    it 'solution receive verify!' do
      expect(quest_solution).to receive(:verify!).with(false)
      quest_solution.decline!
    end
  end # context '.decline!'

  context '.verify!' do
    let!(:quest_solution) { create(:quest_solution) }
    
    context 'when verified' do
      before { quest_solution.send :verify!, false }

      it 'don\'t receive update' do
        expect(quest_solution).to_not receive(:update!)
        quest_solution.send :verify!, true
      end

      it 'add error' do
        quest_solution.send :verify!, true
        expect(
          quest_solution.errors.full_messages
        ).to eq(['Quest solution already verified'])
      end
    end

    context 'when not verified' do
      context 'when passed is true' do
        it 'receive update with passed eq true' do
          expect(quest_solution).to receive(:update!).with(passed: true,
                                                           verified: true)
          quest_solution.send :verify!, true
        end
      end

      context 'when passed is false' do
        it 'receive update with passed eq false' do
          expect(quest_solution).to receive(:update!).with(passed: false,
                                                           verified: true)
          quest_solution.send :verify!, false
        end
      end
    end
  end # context '.verify!'

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
