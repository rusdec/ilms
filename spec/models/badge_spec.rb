require_relative 'models_helper'

RSpec.describe Badge, type: :model do
  it_behaves_like 'authorable'
  it_behaves_like 'grantable'

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }
  it do
    should validate_length_of(:title)
      .is_at_least(3)
      .is_at_most(35)
  end

  it { should belong_to(:badgable) }
  it { should belong_to(:course) }

  context '.hiddens' do
    let!(:hiddens) { create_list(:badge, 2, hidden: true) }
    before { create(:badge) }

    it 'returns hidden badges' do
      expect(Badge.hiddens).to eq(hiddens)
    end
  end
end
