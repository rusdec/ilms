require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:roles).through(:role_users) }
end
