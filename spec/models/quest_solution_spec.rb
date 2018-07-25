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

  context '.validate_unverification_solutions' do
    let!(:quest_solution) { create(:quest_solution) }
    let(:quest_passage) { quest_solution.quest_passage }
    let!(:new_quest_solution) do
      build(:quest_solution, quest_passage: quest_passage)
    end

    context 'when quest passage already have quest solution' do
      context 'and it quest solution is unverified' do
        it 'new quest_solution should be invalid' do
          expect(new_quest_solution).to_not be_valid
        end
      end

      context 'and it solution is verified' do

        context 'and accepted' do
          before { quest_solution.accept! }
        end

        context 'and declined' do
          before { quest_solution.decline! }

          it 'new quest_solution should be valid' do
            expect(new_quest_solution).to be_valid
          end
        end
      end # context 'when it solution is verified'
    end # context 'when quest_passage have quest_solution'
  end # context 'validate_unverification_solutions'

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
    quest_solution = create(:quest_solution)
    quest_passage = quest_solution.quest_passage
    auditor = quest_passage.quest.author

    create_list(:quest_solution, 4)

    expect(
      QuestSolution.for_auditor(auditor).order(:created_at)
    ).to eq(quest_passage.quest_solutions.order(:created_at))
  end

  context '#unverified' do
    let!(:quest_solution) { create(:quest_solution) }
    let(:quest_passage) { quest_solution.quest_passage }
    before { quest_solution.decline! }
    
    it 'should not include verified' do
      expect(QuestSolution.unverified).to_not include(quest_solution)
    end

    it 'should include unverified' do
      expect(QuestSolution.unverified).to eq(QuestSolution.where(verified: false))
    end
  end

  it '#unverified_for_auditor' do
    quest_solution = create(:quest_solution)
    auditor = quest_solution.quest_passage.quest.author
    quest_solution.decline!

    expect(
      QuestSolution.unverified_for_auditor(auditor)
    ).to_not include(quest_solution)
  end

  context '.declined' do
    let!(:declined_quest_solutions) do
      create_list(:quest_solution, 5, verified: true)
    end
    before { create_list(:quest_solution, 5) }

    it 'return declined quest solutions' do
      expect(QuestSolution.declined).to eq(declined_quest_solutions)
    end
  end
end
