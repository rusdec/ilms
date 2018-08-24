require_relative '../../features_helper'

feature 'Create course', %q{
  As user
  I can create course
  so that I can learn other peoples
} do

  before do
    sign_in(create(:course_master))
    visit course_master_courses_path
    click_on 'Create your course'
  end

  context 'with valid data' do
    scenario 'can create course', js: true do
      course = attributes_for(:course)
      within 'form' do
        fill_in 'Title', with: course[:title]
        fill_editor 'Decoration description', with: course[:decoration_description]
        check 'Published'
        click_on 'Create'
      end

      expect(page).to have_content('Success')
      expect(page).to have_content('Edit Course')
      expect(page).to have_link('Create Badge')
    end
  end

  scenario 'see title course properties' do
    ['Title', 'Decoration description',
     'Level', 'Published'].each do |property|
      expect(page).to have_content(property)
    end
  end

  scenario 'can\'t create badge' do
    expect(page).to_not have_content('Badge')
    expect(page).to_not have_link('Create Badge')
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
