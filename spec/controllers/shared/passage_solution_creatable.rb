shared_examples_for 'passage_solution_creatable' do
  it 'create new quest solution for quest passage' do
    expect{
      post :create, params: params
    }.to change(passage.solutions, :count).by(1)
  end

  it 'return success object' do
    post :create, params: params
    expect(response).to match_json_schema('passage_solutions/create/success')
  end
end
