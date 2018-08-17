require_relative '../../features_helper'

feature 'Create course', %q{
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
        click_on 'Create Badge'
      end

      expect(page).to have_content('Success')
      expect(page).to have_content(badge[:title])
      expect(page).to have_content(format_date(badge[:created_at]))
    end
  end

  context 'with invalid data' do
    scenario 'can\'t create course', js: true do
      within 'form' do
        fill_in 'Title', with: ''
        click_on 'Create Badge'
      end

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Title is too short')
    end
  end
end 
