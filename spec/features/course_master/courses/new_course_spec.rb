require_relative '../../features_helper'

feature 'Create course', %q{
  As user
  I can create course
  so that I can learn other peoples
} do

  before do
    sign_in(create(:course_master))
    visit new_course_master_course_path
  end

  context 'with valid data' do
    scenario 'can create course', js: true do
      course = attributes_for(:course)
      within 'form' do
        fill_in 'Title', with: course[:title]
        fill_editor 'Decoration description', with: course[:decoration_description]
        click_on 'Create'
      end

      [course[:title],
       course[:decoration_description],
       course[:level],
       course[:created_at]
      ].each { |text| expect(page).to have_content(text) }
    end
  end

  context 'with invalid data' do
    scenario 'can\'t create course', js: true do
      within 'form' do
        fill_in 'Title', with: ''
        click_on 'Create'
      end

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Title is too short')
    end
  end
end 
