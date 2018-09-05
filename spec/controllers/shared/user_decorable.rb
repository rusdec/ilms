shared_examples_for 'user_decorable' do
  it 'assigns user to @user' do
    expect(assigns(:user)).to eq(user)
  end

  it 'decorates assigned user' do
     expect(assigns(:user)).to be_decorated
  end
end
