require_relative '../../features_helper'

feature 'See lessons', %q{
  As author of course
  I can see course's lessons
  so that I choose which lesson will remove or edit or somethink else
} do

  given(:user) { create(:course_master) }
  given(:course) { create(:course, author: user) }
  given!(:lessons) { create_list(:lesson, 3, course: course, author: user) }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_course_lessons_path(course, locale: I18n.locale)
    end

    it_behaves_like 'having_course_tabs'

    scenario 'see breadcrumb' do
      within '.breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        expect(page).to have_link(course.decorate.title_preview)
        expect(page).to have_content('Lessons')
      end
    end

    scenario 'see lessons' do
      expect(page).to have_content('Lessons')
      lessons.each do |lesson|
        expect(page).to have_link(lesson.decorate.title_preview)
        expect(page).to have_content(lesson.decorate.created_at)
      end
    end

    it_behaves_like 'having_remote_links' do
      given(:resources) { lessons }
      given(:container) { '.lesson-items' }
    end
  end # scenario 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_course_lessons_path(course, locale: I18n.locale)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
    end
  end # context 'when not author'
end
