# @params Enumerable resources
shared_examples_for 'having_remote_links' do
  scenario 'user see remote links' do
    within container do
      expect(page).to have_css("a.edit", count: resources.count)
      expect(page).to have_css("a.destroy", count: resources.count)
    end
  end
end
