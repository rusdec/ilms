# @params Enumerable resources
shared_examples_for 'having_remote_links' do
  scenario 'user see remote links' do
    expect(page).to have_link('Delete', count: resources.count)
    expect(page).to have_link('Edit', count: resources.count)
  end
end
