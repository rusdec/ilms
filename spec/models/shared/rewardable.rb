shared_examples_for 'rewardable' do
  it { should have_many(:user_grantables).dependent(:destroy) }
  it do
    should have_many(:badges)
      .through(:user_grantables)
      .source(:grantable)
  end
end
