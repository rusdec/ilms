require_relative 'models_helper'

RSpec.describe Knowledge, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it do
    should validate_length_of(:name)
      .is_at_least(3)
      .is_at_most(50)
  end
  it { should have_db_index(:name).unique }

  it do
    should have_many(:course_knowledges)
      .dependent(:destroy)
      .inverse_of(:knowledge)
  end
  it { should have_many(:courses).through(:course_knowledges) }

  it { should have_many(:user_knowledges).dependent(:destroy) }
  it { should have_many(:users).through(:user_knowledges) }

  context 'default_scope' do
    let!(:knowledge_b) { create(:knowledge, name: 'Bknowledge') }
    let!(:knowledge_a) { create(:knowledge, name: 'Aknowledge') }

    it 'order by name asc' do
      expect(Knowledge.all).to eq([knowledge_a, knowledge_b])
    end
  end

  context 'downcase name' do
    let!(:knowledge) { build(:knowledge) }

    it 'downcases name before validation' do
      expect(knowledge.name).to receive(:downcase!)
      knowledge.valid?
    end

    it 'not downcases if name is nil' do
      knowledge.name = nil
      expect(knowledge.name).to_not receive(:downcase!)
      knowledge.valid?
    end
  end # context 'downcase name'

  context 'new_knowledges_for' do
    let!(:any_knowledgable) { double('AnyKnowledgable') }
    let!(:other_knowledgable) { double('AnyKnowledgable') }

    it 'returns all knowledges' do
      knowledges = create_list(:knowledge, 3)
      allow(any_knowledgable).to receive(:knowledges) { Knowledge.all }
      allow(other_knowledgable).to receive(:knowledges) { Knowledge.where(id: nil) }

      expect(
        any_knowledgable.knowledges.new_for(other_knowledgable)
      ).to eq(knowledges)
    end

    it 'return last knowledge' do
      create_list(:knowledge, 2)
      knowledges = create_list(:knowledge, 1)

      allow(any_knowledgable).to receive(:knowledges) { Knowledge.all }
      allow(other_knowledgable).to receive(:knowledges) do
        Knowledge.where.not(id: Knowledge.last)
      end
      
      expect(
        any_knowledgable.knowledges.new_for(other_knowledgable)
      ).to eq(knowledges)
    end
  end
end
