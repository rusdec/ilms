require_relative '../../features_helper'

feature 'Edit lesson', %q{
  As author of lesson
  I can edit lesson
  so that I can update details of lesson
} do
  given(:user) { create(:course_master) }
  given!(:lesson) { create(:course, :with_lesson, author: user).lessons.last }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_lesson_path(lesson)
      click_on 'Edit'
    end

    context 'with valid data' do
      scenario 'can create new lesson', js: true do
        expect(page).to have_content('Edit lesson')

        fill_in 'Title', with: 'NewLessonTitle'
        click_on 'Update lesson'

        expect(page).to have_content('Success')
      end # scenario 'can create new lesson'
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        expect(page).to have_content('Edit lesson')

        fill_in 'Title', with: ''
        click_on 'Update lesson'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
      end
    end
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_lesson_path(lesson)
    end

    scenario 'redirect to root' do
      expect(page).to_not have_content('New lesson')
      expect(page).to_not have_content('Update lesson')
    end
  end
end
