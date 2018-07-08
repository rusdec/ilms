require_relative '../../features_helper'

feature 'User see courses', %q{
  As user of Manage panel
  I can see list of courses
  so that I can see all created courses
} do
  
  manage_roles.each do |role|
    context "#{role}" do
      let(:user) { create(role.underscore.to_sym) }
      let!(:courses) { create_list(:course, 5, user_id: user.id) }
      before do
        sign_in(user)
        visit course_master_courses_path
      end

      scenario 'see all courses' do
        courses.each { |course| expect(page).to have_link(course.title) }
      end

      scenario 'see Create your course link' do
        expect(page).to have_link('Create your course')
      end
    end
  end
end
