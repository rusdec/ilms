require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:badge) }
end
