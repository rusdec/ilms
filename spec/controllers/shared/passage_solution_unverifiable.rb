shared_examples_for 'passage_solution_unverifiable' do
  it 'can\'t update passage_solution' do
    expect(passage_solution).to be_unverified
  end

  it 'return error object' do
    expect(response).to match_json_schema('shared/errors')
  end
end
