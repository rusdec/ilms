shared_examples_for 'quest_solution_non_creatable' do
  it 'can\'t create quest_solution for quest_passage' do
    expect{
      post :create, params: params
    }.to_not change(quest_passage.quest_solutions, :count)
  end

  it 'return error object' do
    post :create, params: params
    expect(response).to match_json_schema('shared/errors')
  end
end
