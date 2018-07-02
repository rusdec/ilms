require 'rails_helper'

RSpec.describe RoleUser, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:role) }
end
