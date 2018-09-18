require_relative '../../features_helper'

feature 'Create course', %q{
  As user
  I can create course
  so that I can learn other peoples
} do

  let!(:knowledge) { create(:knowledge) }
  before do
    sign_in(create(:course_master))
    visit course_master_courses_path
    click_on 'Create Course'
  end

  context 'with valid data' do
    scenario 'can create course', js: true do
      course = attributes_for(:course)
      within 'form' do
        fill_in 'Title', with: course[:title]
        fill_in 'Short description', with: 'NewValidShortDescription'
        fill_editor 'Decoration description', with: course[:decoration_description]
        select_knowledge(knowledge.name)
        set_percent_for_knowledge(knowledge.name, 100)
        check 'Published'
        click_on 'Create'
      end

      expect(page).to have_content('Success')
      expect(page).to have_content('Edit course')
      expect(page).to have_link('New badge')
    end
  end

  scenario 'see breadcrumb' do
    within '.breadcrumb' do
      expect(page).to have_link('Manage courses')
      expect(page).to have_link('Courses')
      expect(page).to have_content('New course')
    end
  end

  scenario 'see course properties' do
    ['Title', 'Decoration\'s description', 'Short description',
     'Difficulty', 'Published', 'Knowledges', 'Image'].each do |property|
      expect(page).to have_content(property)
    end
  end

  scenario 'can\'t create badge' do
    expect(page).to_not have_content('Badge')
    expect(page).to_not have_link('New Badge')
  end

  context 'with invalid data' do
    scenario 'can\'t create course', js: true do
      within 'form' do
        fill_in 'Title', with: ''
        click_on 'Create'
      end

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Title is too short')
      expect(page).to have_content('Total percent of knowledges must equal 100% now 0%')
    end
  end
end 
