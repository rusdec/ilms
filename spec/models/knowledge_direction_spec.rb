require 'rails_helper'

RSpec.describe KnowledgeDirection, type: :model do
  it { should have_many(:knowledges).inverse_of(:direction) }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it { should validate_presence_of(:name) }
  it do
    should validate_length_of(:name)
      .is_at_least(3)
      .is_at_most(50)
  end

  context 'downcase name' do
    let!(:knowledge_direction) { build(:knowledge_direction) }

    it 'downcases name before validation' do
      expect(knowledge_direction.name).to receive(:downcase!)
      knowledge_direction.valid?
    end

    it 'not downcases if name is nil' do
      knowledge_direction.name = nil
      expect(knowledge_direction.name).to_not receive(:downcase!)
      knowledge_direction.valid?
    end
  end # context 'downcase name'

end
