shared_examples_for 'failure_to_update_a_user' do
  before do
    patch :update, params: params
    user.reload
  end

  it 'not updates data' do
    expect(user.email).to eq(original_email)
    expect(user.name).to eq(original_name)
    expect(user.surname).to eq(original_surname)
    expect(user.avatar.file).to be_nil
  end

  it 'returns error' do
    expect(response).to match_json_schema(json_error_schema)
  end
end
