shared_examples_for 'grantable' do
  it { should have_many(:user_grantables).dependent(:destroy) }
  it { should have_many(:rewarders).through(:user_grantables).class_name('User') }
end
