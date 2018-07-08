require_relative '../../features_helper'

feature 'Show user', %q{
  As Administrator
  I can view user page
  so that I can view all details info about it user
} do

  given(:user) { create(:user) }
  before do
    sign_in(create(:administrator))
    visit administrator_user_path(user)
  end

  context 'when administrator' do
    scenario 'see user info' do
      [user.email,
       user.type,
       user.full_name,
       format_date(user.created_at)
      ].each { |text| expect(page).to have_content(text) } 
    end

    scenario 'see avatar' do
      expect(page).to have_css('.image-big-avatar')
    end
  end
end
