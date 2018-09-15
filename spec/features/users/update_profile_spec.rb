require_relative '../features_helper'

feature 'User update profile', %q{
  As user
  I can update own profile
  so that I can change my name, surname, avatar, password
} do

  given!(:user) { create(:user).decorate }

  context 'when authenticated user' do
    before { sign_in(user) }

    context 'and user visit own profile page' do
      context 'when data is valid' do
        given!(:attributes) { attributes_for(:user) }

        scenario 'can update profile', js: true do
          expect(page).to have_content('Profile')

          fill_in 'Name', with: attributes[:name]
          fill_in 'Surname', with: attributes[:surname]
          fill_in 'Email', with: attributes[:email]
          fill_in 'Current password', with: attributes[:password]
          fill_in 'Password', with: 'new_password'
          fill_in 'Password confirmation', with: 'new_password'

          Capybara.using_wait_time(7) do
            click_on 'Save'
            expect(page).to have_content('Success')
            expect(page).to have_content("#{attributes[:name]} #{attributes[:surname]}")
            expect(page).to have_content(attributes[:email])
            expect(page).to have_content(
              "#{attributes[:name].first}#{attributes[:surname].first}",
              count: 3
            )
            
            within '.top_header' do
              expect(page).to have_content("#{attributes[:name]} #{attributes[:surname]}")
            end
          end
        end # scenario 'can update profile'
      end # context 'when data is valid' do

      context 'when data is not valid' do
        scenario 'can\'t update profile', js: true do
          fill_in 'Name', with: ''
          fill_in 'New password', with: '123'
          fill_in 'Surname', with: ''
          fill_in 'Email', with: ''

          Capybara.using_wait_time(7) do
            click_on 'Save'
            expect(page).to_not have_content('Success')

            expect(page).to have_content(user.name)
            expect(page).to have_content(user.surname)
            expect(page).to have_content(user.email)
            expect(page).to have_content(user.initials, count: 3)

            expect(page).to have_content('Email can\'t be blank')
            expect(page).to have_content('Name can\'t be blank')
            expect(page).to have_content('Name is too short')
            expect(page).to have_content('Surname can\'t be blank')
            expect(page).to have_content('Surname is too short')
            expect(page).to have_content('Current password can\'t be blank')
            expect(page).to have_content('Password confirmation doesn\'t match Password')
            expect(page).to have_content('Password is too short')
          end
        end
      end # context 'when data is not valid'
    end # context 'and user open own profile page'

    context 'and user visit foreign profile page' do
      given!(:other_user) { create(:user).decorate }
      before { visit user_path(other_user, locale: I18n.locale) }

      scenario 'see user info' do
        within '.top_header' do
          expect(page).to have_content(other_user.initials, count: 1)
        end
        within '.user-container' do
          expect(page).to have_content(other_user.initials, count: 1)
        end
        expect(page).to have_content(other_user.name)
        expect(page).to have_content(other_user.surname)
        expect(page).to have_content(other_user.email)
      end

      scenario 'can\'t update foreign profile'  do
        expect(page).to_not have_content('My profile')
        expect(page).to_not have_content('Remove avatar')
        expect(page).to_not have_content('New password')
        expect(page).to_not have_content('Current password')
        expect(page).to_not have_content('Password')
      end
    end # context 'and user visit foreign profile page'
  end # context 'when authenticated user'
end
