require 'rails_helper'

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
  end
end
