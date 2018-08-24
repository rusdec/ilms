require_relative '../../features_helper'

feature 'User see courses', %q{
  As user of Manage panel
  I can see list of courses
  so that I can see all created courses
} do
  
  context "when CourseMaster" do
    given(:user) { create(:course_master, :with_courses) }
    before do
      sign_in(user)
      visit course_master_courses_path
    end

    scenario 'see all courses' do
      courses = CourseDecorator.decorate_collection(user.courses)

      courses.each do |course|
        expect(page).to have_link(course.title)
        expect(page).to have_content(course.created_at)
      end
    end

    scenario 'see create your course link' do
      expect(page).to have_link('Create your course')
    end

    it_behaves_like 'having_remote_links' do
      let(:resources) { user.courses }
    end
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
