require_relative '../../features_helper'

feature 'Edit badge', %q{
  As author of badge
  I can edit own badge
  so that I can supplement description, title, image
} do

  given!(:course) { create(:course) }
  given!(:badge) do
    BadgeDecorator.decorate(
      create(:badge, badgable: course, course: course, author: course.author)
    )
  end
  
  context 'when author' do
    before do
      sign_in(course.author)
      visit edit_course_master_course_path(course)
      click_on 'Badges'
      within ".badge-item[data-id='#{badge.id}']" do
        click_on 'Edit'
      end
    end

    scenario 'can back to badges' do
      click_on 'Badges'
      expect(page).to have_content('Edit Course')
      course.badges.each do |badge|
        expect(page).to have_content(badge.title)
      end
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:badge) }

      scenario 'can update badge', js: true do
        within 'form' do
          fill_in 'Title', with: attributes[:title]
          fill_editor 'Description', with: attributes[:description]
          attach_file(badge.image.path)
          click_on 'Update Badge'
        end

        expect(page).to have_content('Success')
      end
    end
    context 'with invalid data' do
      scenario 'can\'t update badge', js: true do
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
  end # context 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_badge_path(badge)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end 
