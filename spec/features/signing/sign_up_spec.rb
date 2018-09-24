require_relative '../features_helper'

feature 'Signing up', %q{
  As user
  I can sign up with name, surname and email
  so that I can use application
} do
  before { visit new_user_registration_path }

  scenario 'User can\'n register without name, surname and email' do
    within 'form' do
      fill_in 'Password', with: 'qwerty'
      fill_in 'Confirm password', with: 'qwerty'
      click_on 'Sign up'
    end

    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Surname can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
  end

  scenario 'User can register with valid data' do
    within 'form' do
      fill_in 'user_name', with: 'UserName'
      fill_in 'user_surname', with: 'UserSurname'
      fill_in 'user_email', with: 'user@email.org'
      fill_in 'user_password', with: 'qwerty'
      fill_in 'user_password_confirmation', with: 'qwerty'
      click_on 'Sign up'
    end

    expect(page).to_not have_content('Sign in')
    expect(page).to_not have_content('Sign up')
    expect(page).to have_content('Welcome! You have signed up successfully')

    within '.top_header' do
      expect(page).to have_content('UserName UserSurname')
      expect(page).to have_content('User')
      click_on('UserName UserSurname')
      expect(page).to have_link('Sign out')
    end

    expect(page).to have_content('UserName UserSurname')
    expect(page).to have_content('No data', count: 5)
    expect(page).to have_link('Profile')
    expect(page).to have_link('Knowledges')
    expect(page).to have_link('My Courses')
    expect(page).to have_link('Badges')
  end
end
