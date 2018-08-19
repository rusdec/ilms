require_relative '../../features_helper'

feature 'Edit badge', %q{
  As author of badge
  I can edit own badge
  so that I can supplement description, title, image
} do

  given(:user) { create(:course_master) }
  given!(:badge) { create(:badge, author: user) }
  
  context 'when author' do
    before do
      sign_in(user)
      visit course_master_badges_path
      click_on 'Edit'
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:badge) }

      scenario 'can update badge', js: true do
        within 'form' do
          fill_in 'Title', with: attributes[:title]
          fill_editor 'Description', with: attributes[:description]
          attach_file(badge.image.path)
          click_on 'Update Badge'
        end

        expect(page).to have_content('Success')
      end
    end
    context 'with invalid data' do
      scenario 'can\'t update badge', js: true do
        within 'form' do
          fill_in 'Title', with: ''
          click_on 'Update'
        end

        [
          'Title can\'t be blank',
          'Title is too short',
        ].each { |error| expect(page).to have_content(error) }
      end
    end
  end # context 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_badge_path(badge)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end 
