require_relative '../models_helper'

RSpec.describe Rewardable, type: :model do
  with_model :any_grantable do
    model do
      include Grantable
    end
  end

  let!(:rewardable) { create(:user) }
  let!(:grantable) { AnyGrantable.create }

  context '.reward!' do
    it 'relates rewardable with grantable' do
      rewardable.reward!(grantable)
      expect(
        rewardable.user_grantables.last.grantable
      ).to eq(grantable)
    end
  end
end
