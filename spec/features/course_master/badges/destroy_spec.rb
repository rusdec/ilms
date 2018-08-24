require_relative '../../features_helper'

feature 'Delete badge', %q{
  As author of course
  I can delete badge
  so that it does not exist
} do
  
  context 'when user with any manage role' do
    given!(:course) { create(:course) }
    given!(:badge) do
      BadgeDecorator.decorate(
        create(:badge, badgable: course, course: course, author: course.author)
      )
    end

    before do
      sign_in(course.author)
      visit edit_course_master_course_path(course)
      click_on 'Badges'
    end

    scenario 'can delete badge', js: true do
      within ".badge-item[data-id='#{badge.id}']" do
        click_on 'Delete'
      end

      Capybara.using_wait_time(5) do
        expect(page).to have_content('Success')
        expect(page).to_not have_link('Delete')
      end
      expect(page).to_not have_content(badge.title_preview)
    end
  end # context 'when user with any manage role'
end
