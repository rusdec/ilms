require_relative '../../features_helper'

feature 'Destory lesson', %q{
  As author of lesson
  I can delete lesson
  so that I no one had any access to it
} do

  given(:user) { create(:course_master) }
  given!(:lesson) { create(:course, :with_lesson, author: user).lessons.last }
  
  context 'Author' do
    before do
      sign_in(user)
      visit course_master_lesson_path(lesson)
    end

    scenario 'can delete course', js: true do
      click_on 'Delete'

      expect(page).to have_content('Success')
      expect(page).to have_content(lesson.course.title)
      expect(page).to_not have_content(lesson.title)
    end
  end
end 
