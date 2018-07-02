require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:surname) }

  it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  it { should validate_length_of(:surname).is_at_least(2).is_at_most(20) }
end
