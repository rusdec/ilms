shared_examples_for 'quest_solution_creatable' do
  it 'create new quest solution for quest passage' do
    expect{
      post :create, params: params
    }.to change(quest_passage.quest_solutions, :count).by(1)
  end

  it 'return success object' do
    post :create, params: params
    expect(response).to match_json_schema('quest_solutions/create/success')
  end
end
