require_relative 'models_helper'

RSpec.describe Passage, type: :model do
  with_model :any_passable do
    model do
      has_many :passages, as: :passable
    end
  end

  it { should be_a_closure_tree }
  it { should belong_to(:user) }
  it { should belong_to(:passable) }

  it_behaves_like 'statusable'

  context '#in_progress?' do
    let(:user) { create(:user) }
    let!(:status) { create(:status, :in_progress) }
    let!(:passable) { AnyPassable.create }

    context 'when passage in progress' do
      before { create(:passage, user: user, passable: passable, status: status) }

      it 'should return true' do
        expect(Passage).to be_in_progress(passable)
      end
    end

    context 'when passage not in progress' do
      it 'should return false' do
        expect(Passage).to_not be_in_progress(passable)
      end
    end
  end

  context '.validate_passage_in_progress' do
    let(:user) { create(:user) }
    let!(:status) { create(:status, :in_progress) }
    let!(:passable) { AnyPassable.create }

    context 'when passage in progress' do
      before { create(:passage, user: user, passable: passable, status: status) }
      let!(:passage) do
        build(:passage, user: user, passable: passable, status: status)
      end

      it 'passage should be invalid' do
        expect(passage).to_not be_valid
      end

      it 'should contains error' do
        passage.valid?
        expect(passage.errors.full_messages).to eq(['Any passable in progress'])
      end
    end

    context 'when passage not in progress' do
      it 'passage should be valid' do
        passage = build(:passage, user: user, passable: passable, status: status)
        expect(passage).to be_valid
      end
    end
  end
end
