require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'default value is user' do
    expect(create(:role).name).to eq('user')
  end

  it { should have_many(:users).through(:role_users) }
end
