require_relative '../features_helper'

feature 'Signing in', %q{
  As user
  I can sign in with my email and password
  so that I can use application
} do
  given!(:user) { create(:user, password: 'qwerty') }
  before { visit new_user_session_path }

  scenario 'User can\'n sign in with invalid data' do
    within 'form' do
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      click_on 'Log in'
    end

    expect(page).to have_content('Sign In')
    expect(page).to have_content('Sign Up')
    expect(page).to have_content('Invalid Email or password')

    expect(page).to_not have_content('Profile')
  end

  scenario 'User can sign in with valid data' do
    within 'form' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'qwerty'
      click_on 'Log in'
    end

    expect(page).to_not have_content('Sign In')
    expect(page).to_not have_content('Sign Up')
    expect(page).to have_content('Signed in successfully')

    within '.top_header' do
      expect(page).to have_content(user.decorate.full_name)
      expect(page).to have_content('User')
      click_on(user.decorate.full_name)
      expect(page).to have_link('Sign out')
    end

    expect(page).to have_content(user.decorate.full_name)
    expect(page).to have_content('No data', count: 5)
    expect(page).to have_link('Profile')
    expect(page).to have_link('Knowledges')
    expect(page).to have_link('My Courses')
    expect(page).to have_link('Badges')
  end
end
