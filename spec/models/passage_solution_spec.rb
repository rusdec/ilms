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
  let(:passage) { create(:passage, passable: passable, user: create(:user)) }
  let!(:passage_solution) { create(:passage_solution, passage: passage) }

  let(:html_validable) { { field: :body, object: passage_solution } }
  it_behaves_like 'html_presence_validable'
  it_behaves_like 'html_attributable', %i(body)
  it_behaves_like 'statusable'

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

  it '#for_auditor' do
    quest = create(:quest)
    passage = create(:passage, passable: quest, user: create(:user))
    create(:passage_solution, passage: passage)

    expect(PassageSolution.for_auditor(quest.author)).to eq(passage.solutions)
  end

  it '#unverified_for_auditor' do
    quest = create(:quest)
    passage = create(:passage, passable: quest, user: create(:user))
    create(:passage_solution, passage: passage).declined!
    create(:passage_solution, passage: passage)

    expect(
      PassageSolution.unverified_for_auditor(quest.author)
    ).to eq(passage.solutions.all_unverified)
  end
end
