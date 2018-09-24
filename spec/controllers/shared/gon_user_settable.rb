shared_examples_for 'gon_user_settable' do
  after { Gon.clear }

  it 'gonifies statistic user' do
    expect(controller.gon.statistic_user).to eq(assigns(:user))
  end
end
