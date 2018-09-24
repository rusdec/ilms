require_relative '../../features_helper'

feature 'See badges', %q{
  As author of course
  I can see course's  badges
  so that I choose which badge will remove or edit or somethink else
} do
  
  context 'when user with any manage role' do
    context 'when author of course' do
      given!(:course) { create(:course) }
      given!(:badges) do
        create(:badge, badgable: course, course: course, author: course.author)
        create(:badge, badgable: create(:quest), course: course, author: course.author)
        BadgeDecorator.decorate_collection(course.badges)
      end

      before do
        sign_in(course.author)
        visit course_master_course_badges_path(course, locale: I18n.locale)
      end

      scenario 'see breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        expect(page).to have_link(course.decorate.title_preview)
        expect(page).to have_content('Badges')
      end

      scenario 'see badges' do
        badges.each do |badge|
          expect(page).to have_link(badge.decorate.title_preview)
          expect(page).to have_content(badge.decorate.created_at)
        end
      end

      it_behaves_like 'having_course_tabs'
      it_behaves_like 'having_remote_links' do
        given(:resources) { badges }
        given(:container) { '.badge-items' }
      end
    end # context 'when author of course'
  end # context 'when user with any manage role'
end
