require_relative '../../features_helper'

feature 'User see courses', %q{
  As user of Manage panel
  I can see list of courses
  so that I can see all created courses
} do
  
  context 'when user with any manage role' do
    manage_roles.each do |role|
      context "when #{role}" do
        given(:user) { create(role.underscore.to_sym, :with_courses) }
        before do
          sign_in(user)
          visit course_master_courses_path
        end

        scenario 'see all courses' do
          user.courses.each { |course| expect(page).to have_link(course.title) }
        end

        scenario 'see create your course link' do
          expect(page).to have_link('Create your course')
        end
      end
    end # manage_roles.each do |role|
  end # context 'when user with any manage role'

  context 'when user without manage role' do
    before do
      sign_in(create(:user))
      visit course_master_courses_path
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end
