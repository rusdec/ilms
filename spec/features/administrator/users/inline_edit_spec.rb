require_relative '../../features_helper'

feature 'Inline edit user', %q{
  As Administrator
  I can inline edit user
  so that I can update some user values faster
} do

  context 'when administrator' do
    given!(:user) { create(:user) }
    before do
      sign_in(create(:administrator))
      visit administrator_users_path
    end

    context 'when update role' do
      scenario 'can update user role', js: true do
        within first('td.role') do
          expect(page).to have_content('User')
          click_on 'Edit'
          select 'Course master', from: 'user[type]'
          click_on 'Save'

          expect(page).to have_content('Course master')
        end

        expect(page).to have_content('Success')
        expect(page).to_not have_link('Cancel')
        expect(page).to_not have_link('Save')
      end
    end
  end
end
