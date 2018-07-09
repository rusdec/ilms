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

    [
      'Name can\'t be blank',
      'Surname can\'t be blank',
      'Email can\'t be blank'
    ].each { |text| expect(page).to have_content text }
  end

  scenario 'User can register with valid data' do
    within 'form' do
      fill_in 'Name', with: 'UserName'
      fill_in 'Surname', with: 'UserSurname'
      fill_in 'Email', with: 'user@email.org'
      fill_in 'Password', with: 'qwerty'
      fill_in 'Confirm password', with: 'qwerty'
      click_on 'Sign up'
    end

    ['Sign in', 'Sign up'].each { |text| expect(page).to_not have_content text }

    [
      'Sign out',
      'Welcome! You have signed up successfully.'
    ]. each { |text| expect(page).to have_content text }
  end
end
