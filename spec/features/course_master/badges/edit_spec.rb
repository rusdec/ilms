require_relative '../../features_helper'

feature 'Edit badge', %q{
  As author of badge
  I can edit own badge
  so that I can supplement description, title, image
} do

  given!(:course) { create(:course) }
  given!(:badge) do
    create(:badge, badgable: course, course: course, author: course.author).decorate
  end
  
  context 'when author' do
    before do
      sign_in(course.author)
      visit edit_course_master_course_path(course, locale: I18n.locale)
      click_on 'Badges'
      within ".badge-item[data-id='#{badge.id}']" do
        click_on 'Edit'
      end
    end

    scenario 'see breadcrumb' do
      within '.breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        expect(page).to have_link(course.decorate.title_preview)
        expect(page).to have_content(badge.title)
      end
    end

    scenario 'can back to badges' do
      click_on 'Back to badges'
      expect(page).to have_content('Edit course')
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
          click_on 'Save'
        end

        expect(page).to have_content('Success')
      end
    end
    context 'with invalid data' do
      scenario 'can\'t update badge', js: true do
        within 'form' do
          fill_in 'Title', with: ''
          click_on 'Save'
        end

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
      end
    end
  end # context 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_badge_path(badge, locale: I18n.locale)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end 
