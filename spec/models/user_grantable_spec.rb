require 'rails_helper'

RSpec.describe UserGrantable, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:grantable) }
end
