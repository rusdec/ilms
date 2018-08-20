require_relative '../../features_helper'

feature 'User see badges', %q{
  As user of Manage panel
  I can see list of badges
  so that I can see all created badges
} do
  
  context 'when user with any manage role' do
    given(:user) { create(:course_master) }
    before do
      3.times { create(:badge, author: user) }
      sign_in(user)
      visit course_master_badges_path
    end

    scenario 'see all created badges' do
      created_badges = BadgeDecorator.decorate_collection(user.created_badges)
      created_badges.each do |badge|
        expect(page).to have_text(badge.title_preview)
        expect(page).to have_text(badge.description_preview)
        expect(page).to have_content(badge.created_at)
      end

      expect(page).to have_link('Edit', count: created_badges.count)
      expect(page).to have_link('Delete', count: created_badges.count)
    end # scenario 'see all created badges'
  end # context 'when user with any manage role'

  context 'when user without manage role' do
    before do
      sign_in(create(:user))
      visit course_master_courses_path
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end
