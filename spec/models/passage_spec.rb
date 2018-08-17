require_relative 'models_helper'

RSpec.describe Passage, type: :model do
  with_model :any_passable do
    model do
      include Passable

      def passable_children
        OtherPassable.all
      end
    end
  end

  with_model :other_passable do
    model do
      include Passable
    end
  end

  class AnyPassablePassage < Passage; end
  class OtherPassablePassage < Passage; end

  it { should be_a_closure_tree }
  it { should belong_to(:user) }
  it { should belong_to(:passable) }

  it_behaves_like 'statusable'
  it_behaves_like 'solutionable'

  context '#by_type' do
    it 'return objects with given type' do
      [AnyPassable, OtherPassable].each do |passable|
        Passage.create(passable: passable.create, user: create(:user))
      end
      expect(
        Passage.by_type('AnyPassable')
      ).to eq(Passage.where(passable_type: 'AnyPassable'))
    end
  end

  ['courses', 'lessons', 'quests'].each do |scope|
    it "#for_#{scope}" do
      expect(Passage).to receive(:by_type).with(scope.singularize.capitalize)
      Passage.send "for_#{scope}"
    end
  end

  it 'created passage has type related with passables class' do
    passage = Passage.create(passable: AnyPassable.create, user: create(:user))
    expect(passage.type).to eq('AnyPassablePassage')
  end

  context '.passage_after_create_hook' do
    let!(:other_passable) { OtherPassable.create }
    let!(:passage) { Passage.new(passable: AnyPassable.create, user: create(:user)) }

    it 'create passages children' do
      expect{
        passage.save
      }.to change(passage.children, :count).by(1)
    end

    it 'created passages related with passable' do
      passage.save
      expect(passage.children.first.passable).to eq(other_passable)
    end

    it 'created passages related with passage user' do
      passage.save
      expect(passage.children.first.user).to eq(passage.user)
    end
  end

  context '.try_chain_pass!' do
    let!(:course) { create(:course, :full) }
    let!(:passage) do
      create(:passage, passable: course, user: create(:user))
      Passage.last
    end

    context 'when passage is passed' do
      before { passage.passed! }
      it_behaves_like 'not_pass_chainable'
    end

    context 'when passage is not ready to pass' do
      it_behaves_like 'not_pass_chainable'
    end

    context 'when passage is not passed and ready to pass' do
      before do
        allow(passage).to receive(:ready_to_pass?) { true }
      end

      it 'passage should receive passed!' do
        expect(passage).to receive(:passed!)
        passage.try_chain_pass!
      end

      it 'passage should receive after_pass_hook' do
        expect(passage).to receive(:after_pass_hook)
        passage.try_chain_pass!
      end

      it 'parent should receive try_chain_pass!' do
        expect(passage.parent).to receive(:try_chain_pass!)
        passage.try_chain_pass!
      end

      context 'when parent is nil' do
        before { passage.parent = nil }

        it 'parent should not receive try_chain_pass!' do
          expect(passage.parent).to_not receive(:try_chain_pass!)
          passage.try_chain_pass!
        end
      end
    end
  end

  context '.validate_passage_in_progress' do
    context 'when passable already have passage' do
      let(:params) { { user: create(:user), passable: AnyPassable.create } }
      let!(:existed_passage) { create(:passage, params) }
      let(:new_passage) { build(:passage, params) }

      context 'and existed passage in progress' do
        it 'new passage is invalid' do
          expect(new_passage).to_not be_valid
        end

        it 'new passage contains error' do
          new_passage.valid?
          expect(new_passage.errors.full_messages).to eq(['Any passable in progress'])
        end

        context 'new passage may be in progress' do
          it 'new passage is invalid' do
            allow(new_passage).to receive(:can_be_in_progress?) { true }
            expect(new_passage).to be_valid
          end
        end
      end # context 'and existed passage in progress'

      context 'and existed passage not in progress' do
        before do
          existed_passage.accepted!
        end

        it 'new passage should be valid' do
          expect(new_passage).to be_valid
        end
      end
    end # context 'when passable already have passage'
  end
end
