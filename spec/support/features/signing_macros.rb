module Features
  module Signing
    def sign_in(user)
      visit new_user_session_path
      within 'form' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Log in'
      end
    end
  end
end
