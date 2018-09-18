# Variables
#   @param Badgable badgable => any with role Badgable
#   @param Array crumbs => array with object for breadcrumbs between 'Courses' and 'New badge'
#   @param String new_badgable_path => url to create badgable page
shared_examples_for 'badgable' do
  before { sign_in(badgable.author) }

  context 'when edites badgable' do
    before do
      visit polymorphic_path([:edit, :course_master, badgable], locale: I18n.locale)
      click_on 'New badge'
    end

    scenario 'see link to related badgable' do
      expect(page).to have_link("Back to badges")
    end

    scenario 'see breadcrumb' do
      within '.breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        crumbs.each do |crumb|
          expect(page).to have_link(crumb.decorate.title_preview)
        end
        expect(page).to have_content('New badge')
      end
    end

    context 'with valid data' do
      scenario 'can create badge', js: true do
        badge = attributes_for(:badge)
        within 'form' do
          fill_in 'Title', with: badge[:title]
          fill_editor 'Description', with: badge[:description]
          attach_file(badge[:image].path)
          click_on 'Create'
        end
        Capybara.using_wait_time(5) do
          expect(page).to have_content('Edit badge')
          expect(page).to have_content('Success')
          expect(page).to_not have_link('Create Badge')
        end
      end
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create badge', js: true do
        within 'form' do
          fill_in 'Title', with: ''
          click_on 'Create'
        end

        Capybara.using_wait_time(5) do
          expect(page).to have_content('Image can\'t be blank')
          expect(page).to have_content('Title can\'t be blank')
          expect(page).to have_content('Title is too short')
        end
      end
    end # context 'with invalid data'
  end # context 'when edit badgable'

  context 'when creates badgable' do
    before do
      visit new_badgable_path
    end

    scenario 'no see Create Badge link' do
      expect(page).to_not have_link('New badge')
    end
  end # context 'whn creates badgable'
end 
