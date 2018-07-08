require_relative '../../features_helper'

feature 'Administrator home', %q{
  As Administrator
  I can open admin panel
  so that I can configure application
} do
  context 'Administrator' do
    before do
      sign_in(create(:administrator))
      visit administrator_path
    end

    scenario 'see administrator panel title' do
      expect(page).to have_content('Administration')
    end

    scenario 'see users link' do
      expect(page).to have_content('Users')
      expect(page).to have_content(User.count)
    end
  end
end
