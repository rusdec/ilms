require_relative '../../features_helper'

feature 'Destory course', %q{
  As author of course
  I can delete course
  so that I no one had any access to it
} do

  let(:user) { create(:course_master) }
  let!(:course) { create(:course, user_id: user.id) }
  
  context 'Author' do
    before do
      sign_in(user)
      visit course_master_course_path(course)
    end

    scenario 'can delete course', js: true do
      click_on 'Delete'
      expect(page).to have_content('Success')
      expect(page).to_not have_content(course.title)
    end
  end
end 
