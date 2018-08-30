require_relative '../../features_helper'

feature 'Show user', %q{
  As Administrator
  I can view user page
  so that I can view all details info about it user
} do

  given(:user) { UserDecorator.decorate(create(:user)) }
  before do
    sign_in(create(:administrator))
    visit administrator_user_path(user)
  end

  context 'when administrator' do
    scenario 'see user info' do
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.type)
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(user.created_at)
    end

    scenario 'see avatar' do
      expect(page).to have_css('.image-big-avatar')
    end
  end
end
