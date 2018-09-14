require_relative '../../features_helper'

feature 'New lesson', %q{
  As user
  I can create lesson for course
  so that I can structure my course
} do

  given(:user) { create(:course_master) }
  given(:course) { create(:course, :with_lesson, author: user) }

  context 'when author' do
    before do
      sign_in(user)
      visit edit_course_master_course_path(course, locale: I18n.locale)
      click_on 'Lessons'
      click_on 'New lesson'
    end

    context 'with valid data' do
      let(:parent_lesson) { course.lessons.last }
      let(:lesson) { attributes_for(:lesson) }

      scenario 'can create new lesson', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: lesson[:title]
        fill_editor :ideas, with: lesson[:ideas]
        fill_editor :summary, with: lesson[:summary]
        fill_editor :check_yourself, with: lesson[:check_yourself]
        select('3', from: 'Difficulty')
        select parent_lesson.title, from: 'lesson[parent_id]'
        click_on 'Create'

        Capybara.using_wait_time(5) do
          expect(page).to have_content('Success')
          expect(page).to have_content('Back to lessons')
          expect(page).to have_link('Lesson')
          expect(page).to have_link('Materials')
          expect(page).to have_link('Quests')
        end
      end # scenario 'can create new lesson'
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: ''
        click_on 'Create'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
      end
    end
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_course_path(course, locale: I18n.locale)
    end

    scenario 'redirect to root' do
      expect(page).to_not have_content('New Lesson')
      expect(page).to_not have_content(/^Create$/)
    end
  end
end
