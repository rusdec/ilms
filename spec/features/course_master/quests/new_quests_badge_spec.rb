require_relative '../../features_helper'

feature 'Create badge', %q{
  As Course Master
  I can create badge for quest
  so that students can get it
} do
  it_behaves_like 'badgable' do
    given(:badgable) { create(:quest) }
    given(:new_badgable_path) do
      new_course_master_lesson_quest_path(badgable.lesson, locale: I18n.locale)
    end
    given(:crumbs) {
      [
        badgable.course.decorate.title_preview,
        'Lessons',
        badgable.lesson.decorate.title_preview
      ]
    }
  end
end
