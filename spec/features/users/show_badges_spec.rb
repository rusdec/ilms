require_relative '../features_helper'

feature 'Show user', %q{
  As user
  I can open own profile badges page
  so that I can see all my badges
} do

  given!(:user) { create(:user).decorate }
  given!(:courses) { create_list(:course, 2) }
  before do
    courses.each do |course|
      create(:course_passage, passable: course, user: user)
      user.reward!(create(:badge, course: course, badgable: course))
    end
  end

  context 'when authenticated user' do
    context 'and authenticated user open own user page' do
      before do
        sign_in(user)
        visit user_path(user)
        click_on 'Badges'
      end

      scenario 'see courses titles and badges' do
        courses.each do |course|
          expect(page).to have_content(
            "#{course.title} (#{user.collected_course_badges(course).count} from #{course.badges.count})"
          )
        end
      end # scenario 'see courses titles'

      scenario 'see courses badges' do
        user.badges.each do |badge|
          expect(page).to have_content(badge.title)
          expect(page).to have_content("Awarded: #{badge.rewarders.count}")
        end
      end # scenario 'see courses badges'
    end # scenario 'and authenticated user open own user page'
  end # scenario 'when authenticated user'
end
