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
      visit edit_course_master_course_path(lesson.course, locale: I18n.locale)
      click_on 'Lessons'
      click_on 'Edit'
    end

    scenario 'can back to lessons' do
      click_on 'Back to lessons'
      expect(page).to have_content('Edit course')
      lesson.course.lessons.each do |lesson|
        expect(page).to have_content(lesson.title)
      end
    end

    context 'with valid data' do
      scenario 'can create new lesson', js: true do
        fill_in 'Title', with: 'NewLessonTitle'
        fill_editor :summary, with: "NewLessonSummary"
        select('3', from: 'Difficulty')
        click_on 'Save'

        expect(page).to have_content('Success')
      end
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
      end
    end # context 'with invalid data'
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_lesson_path(lesson, locale: I18n.locale)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Edit lesson')
      expect(page).to_not have_content('Save')
    end
  end
end
