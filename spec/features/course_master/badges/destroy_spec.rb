require_relative '../../features_helper'

feature 'User see courses', %q{
  As user of Manage panel
  I can see list of badges
  so that I can see all created badges
} do
  
  context 'when user with any manage role' do
    given(:user) { create(:course_master) }
    given!(:badge) { BadgeDecorator.decorate(create(:badge, author: user)) }
    before do
      puts user.created_badges.inspect
      sign_in(user)
      visit course_master_badges_path
    end

    scenario 'can delete badge', js: true do
      click_on 'Delete'
      expect(page).to have_content('Success')
      expect(page).to_not have_link('Delete')
      expect(page).to_not have_content(badge.title_preview)
    end
  end # context 'when user with any manage role'
end
