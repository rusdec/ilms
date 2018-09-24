shared_examples_for 'able_to_update_a_user' do
  before do
    patch :update, params: params
    user.reload
  end

  it 'updates data' do
    expect(user.email).to eq(attributes[:email])
    expect(user.name).to eq(attributes[:name])
    expect(user.surname).to eq(attributes[:surname])
    expect(user.avatar.file.filename).to eq(avatar.original_filename)
  end

  it 'returns json object' do
    expect(response).to match_json_schema('users/update/profile/success')
  end
end
