require_relative '../../features_helper'

feature 'Show course', %q{
  As author of course
  I can edit own course
  so that I can supplement description, change level, add lessons or something else
} do

  let(:user) { create(:course_master) }
  let!(:course) { create(:course, user_id: user.id) }
  
  context 'Author' do
    before do
      sign_in(user)
      visit edit_course_master_course_path(course)
    end

    context 'with valid data' do
      scenario 'can update course', js: true do
        within 'form' do
          fill_in 'Title', with: 'NewValidTitle'
          click_on 'Update'
        end

        expect(page).to have_content('Success')
      end
    end

    context 'with invalid data' do
      scenario 'can\'t update course', js: true do
        within 'form' do
          fill_in 'Title', with: ''
          click_on 'Update'
        end

        [
          'Title can\'t be blank',
          'Title is too short',
        ].each { |error| expect(page).to have_content(error) }
      end
    end
  end
end 
