require_relative '../features_helper'

feature 'Show user', %q{
  As user
  I can open own profile page
  so that I can see various data about me
} do

  given!(:user) { create(:user).decorate }

  context 'when authenticated user' do
    context 'and authenticated user open own user page' do
      before do
        sign_in(user)
        visit user_path(user, locale: I18n.locale)
      end

      scenario 'see own profile data' do
        expect(page).to have_content('Profile')
        expect(page).to have_content(user.full_name)
        expect(page).to have_content(user.email)
        expect(page).to have_content('Lessons')
        expect(page).to have_content('Courses')
        expect(page).to have_content('Badges')
        expect(page).to have_content('Quests')
        expect(page).to have_content('Top Three Knowlegdes')
        expect(page).to have_content('Edit profile')
      end # scenarion 'see user data'
    end # scenario 'and authenticated user open own user page'
  end # scenario 'when authenticated user'
end
