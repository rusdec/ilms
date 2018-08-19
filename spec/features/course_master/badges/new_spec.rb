require_relative '../../features_helper'

feature 'Create badge', %q{
  As user
  I can create badge
  so that I can attach it to quests, courses, etc
} do

  before do
    sign_in(create(:course_master))
    visit new_course_master_badge_path
  end

  context 'with valid data' do
    scenario 'can create badge', js: true do
      badge = attributes_for(:badge)
      within 'form' do
        fill_in 'Title', with: badge[:title]
        fill_editor 'Description', with: badge[:description]
        attach_file(badge[:image].path)
        click_on 'Create Badge'
      end
      Capybara.using_wait_time(5) do
        expect(page).to have_content('Success')
        expect(page).to have_content(badge[:title])
      end
    end
  end

  context 'with invalid data' do
    scenario 'can\'t create course', js: true do
      within 'form' do
        fill_in 'Title', with: ''
        click_on 'Create Badge'
      end

      Capybara.using_wait_time(5) do
        expect(page).to have_content('Image can\'t be blank')
        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
      end
    end
  end
end 
