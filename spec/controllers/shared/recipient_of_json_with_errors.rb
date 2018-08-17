shared_examples_for 'recipient_of_json_with_errors' do
  it 'return error object' do
    expect(response).to match_json_schema('shared/errors')
  end
end
