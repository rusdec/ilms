shared_examples_for 'passage_solution_non_creatable' do
  it 'can\'t create passage_solution for passage' do
    expect{
      post :create, params: params
    }.to_not change(passage.solutions, :count)
  end

  it 'return error object' do
    post :create, params: params
    expect(response).to match_json_schema('shared/errors')
  end
end
