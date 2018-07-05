require_relative '../../features_helper'

feature 'Show course', %q{
  As user
  I can edit own course
  so that I can supplement description, change level or something else
} do

  let(:user) { create(:course_master) }
  let!(:course) { create(:course, user_id: user.id) }
  
  context 'Author' do
    before do
      sign_in(user)
      visit edit_course_master_course_path(course)
    end

    scenario 'can update course', js: true do
      new_title = 'NewValidTitle'
      new_description = 'NewValidDescriptionText'
      new_level = '3'

      within 'form' do
        fill_in 'Title', with: new_title
        fill_in 'Decoration description', with: new_description
        fill_in 'Level', with: new_level
        click_on 'Update'
      end

      [new_title, new_description, new_level].each do |text|
        expect(page).to have_content(text)
      end

      [course.title, course.level, course.decoration_description].each do |text|
        expect(page).to_not have_content(text)
      end
    end
  end
end 
