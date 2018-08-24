require_relative '../../features_helper'

feature 'Show course', %q{
  As author of course
  I can edit own course
  so that I can supplement description, change level, add lessons or something else
} do

  given!(:user) { create(:course_master) }
  given!(:course) { create(:course, author: user) }
  
  context 'when author' do
    before do
      sign_in(user)
      visit course_master_courses_path
      click_on course.title
    end

    scenario 'see title course properties' do
      ['Title', 'Decoration description',
       'Level', 'Badge', 'Published'].each do |property|
        expect(page).to have_content(property)
      end
    end

    scenario 'see tabs' do
      ['Course', 'Lessons', 'Badges', 'Statistics'].each do |tab|
        expect(page).to have_content(tab)
      end
    end

    scenario 'see link to courses' do
      expect(page).to have_link('Courses')
    end

    context 'with valid data' do
      scenario 'can update course', js: true do
        sleep 5
        within 'form' do
          fill_in 'Title', with: 'NewValidTitle'
          fill_editor 'Decoration description', with: 'NewValidDecorationDescriptio'
          check 'Published'
          click_on 'Update'
        end

        expect(page).to have_content('Success')
      end
    end

    context 'with invalid data' do
      scenario 'can\'t update course', js: true do
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
      visit edit_course_master_course_path(course)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end 
