require_relative '../../features_helper'

feature 'Destory lesson', %q{
  As author of lesson
  I can delete lesson
  so that I no one had any access to it
} do

  given!(:course) { create(:course, :with_lesson) }
  given!(:lesson) { course.lessons.first }
  
  context 'Author' do
    before do
      sign_in(course.author)
      visit edit_course_master_course_path(course)
      click_on 'Lessons'
    end

    scenario 'can delete course', js: true do
      click_on 'Delete'

      expect(page).to have_content('Success')
      expect(page).to_not have_content(lesson.title)
    end
  end
end 