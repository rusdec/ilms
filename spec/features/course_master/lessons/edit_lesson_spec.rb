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
      visit edit_course_master_course_path(lesson.course)
      click_on 'Lessons'
      click_on 'Edit'
    end

    scenario 'can back to lessons' do
      click_on 'Lessons'
      expect(page).to have_content('Edit Course')
      lesson.course.lessons.each do |lesson|
        expect(page).to have_content(lesson.title)
      end
    end

    context 'with valid data' do
      scenario 'can create new lesson', js: true do
        fill_in 'Title', with: 'NewLessonTitle'
        fill_editor :summary, with: "NewLessonSummary"
        click_on 'Update Lesson'

        expect(page).to have_content('Success')
      end
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        fill_in 'Title', with: ''
        click_on 'Update Lesson'

        ['Title can\'t be blank', 'Title is too short'].each do |error|
          expect(page).to have_content(error)
        end
      end
    end # context 'with invalid data'
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_lesson_path(lesson)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Edit lesson')
      expect(page).to_not have_content('Update Lesson')
    end
  end
end
