require_relative '../../features_helper'

feature 'Index user', %q{
  As Administrator
  I can view list of users
  so that I can change any for details view
} do

  before do
    create_list(:user, 5)
    sign_in(create(:administrator))
    visit administrator_users_path
  end
  given!(:users) { UserDecorator.decorate_collection(User.all) }

  context 'when administrator' do
    scenario 'see list of users' do
      expect(page).to have_content('Users')

      users.each do |user|
        expect(page).to have_link(user.full_name)
        [user.email, user.type].each { |text| expect(page).to have_content(text) }
        [user.created_at, user.created_at].each do |date|
          expect(page).to have_content(date)
        end
      end
    end
  end
end
