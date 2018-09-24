require_relative '../../features_helper'

feature 'Destroy course', %q{
  As author of course
  I can delete course
  so that I no one had any access to it
} do

  given!(:user) { create(:course_master) }
  given!(:course) { create(:course, author: user) }
  
  context 'when author' do
    before do
      sign_in(user)
      visit course_master_courses_path
    end

    scenario 'can delete course', js: true do
      click_destory_remote_link
      Capybara.using_wait_time(5) do
        expect(page).to have_content('Success')
        expect(page).to_not have_content(course.title)
      end
    end
  end
end 
