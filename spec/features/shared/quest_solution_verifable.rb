shared_examples_for 'quest_solution_verifable' do
  scenario 'no see accept/decline buttons' do
    expect(page).to_not have_button('Accept')
    expect(page).to_not have_button('Decline')
  end
end
