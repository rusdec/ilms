require_relative 'models_helper'

RSpec.describe PassageSolution, type: :model do
  with_model :any_passable do
    table do |t|
      t.references :user
    end
    model do
      include Passable
      include Authorable
    end
  end

  it { should belong_to(:passage) }

  let(:passable) { AnyPassable.create(author: create(:course_master)) }
  let(:passage) { create(:passage, passable: passable) }
  let!(:passage_solution) { create(:passage_solution, passage: passage) }

  let(:html_validable) { { field: :body, object: passage_solution } }
  it_behaves_like 'html_presence_validable'
  it_behaves_like 'statusable'

  it '#for_auditor' do
    quest = create(:quest)
    passage = create(:passage, passable: quest)
    create(:passage_solution, passage: passage)

    expect(PassageSolution.for_auditor(quest.author, :quests)).to eq(passage.solutions)
  end

  it '#unverified_for_auditor' do
    quest = create(:quest)
    passage = create(:passage, passable: quest)
    create(:passage_solution, passage: passage).declined!
    create(:passage_solution, passage: passage)

    expect(
      PassageSolution.unverified_for_auditor(quest.author, :quests)
    ).to eq(passage.solutions.all_unverified)
  end

  context '.validate_unverification_solutions' do
    let!(:new_passage_solution) do
      build(:passage_solution, passage: passage)
    end

    context 'when quest passage already have quest solution' do
      context 'and it quest solution is unverified' do
        it 'new passage_solution should be invalid' do
          expect(new_passage_solution).to_not be_valid
        end
      end

      context 'and it solution is verified' do
        context 'and accepted' do
          before { passage_solution.accepted! }

          it 'new passage_solution should be valid' do
            expect(new_passage_solution).to be_valid
          end
        end

        context 'and declined' do
          before { passage_solution.declined! }

          it 'new passage_solution should be valid' do
            expect(new_passage_solution).to be_valid
          end
        end
      end # context 'when it solution is verified'
    end # context 'when passage have passage_solution'
  end # context 'validate_unverification_solutions'

  context '.after_update_status_hook' do
    let!(:course) { create(:course, :full) }
    let!(:passage_solution) do
      create(:passage, passable: course)
      create(:passage_solution, passage: Passage.for_quests.last)
    end

    context 'when status updated to accepted' do
      it 'parent should receive try_pass!' do
        expect(passage_solution.passage).to receive(:try_chain_pass!)
        passage_solution.accepted!
      end
    end

    context 'when status updated to declined' do
      it 'parent should not receive try_pass!' do
        expect(passage_solution.passage).to_not receive(:try_chain_pass!)
        passage_solution.declined!
      end
    end
  end
end
