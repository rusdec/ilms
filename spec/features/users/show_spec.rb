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
        visit user_path(user)
      end

      scenario 'see own profile data' do
        expect(page).to have_content('Profile')
        expect(page).to have_content(user.full_name)
      end # scenarion 'see user data'

      scenario 'see own knowledges' do
        create_list(:user_knowledge, 3, user: user)

        user.user_knowledges.each do |user_knowledge|
          expect(page).to have_content(user_knowledge.knowledge.name)
          expect(page).to have_content(user_knowledge.level)
        end
      end # scenario 'see own knowledges'
    end # scenario 'and authenticated user open own user page'
  end # scenario 'when authenticated user'
end
