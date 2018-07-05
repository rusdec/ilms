require_relative '../features_helper'

feature 'Index courses', %q{
  As user
  I can see list of courses
  so that i can change interesting courses
} do

  let(:course_master) { create(:course_master) }
  let!(:courses) { create_list(:course, 5, user_id: course_master.id) }

  context 'User' do
    before do
      sign_in(create(:user))
      visit courses_path
    end

    it 'can see list of courses' do
      courses.each { |course| expect(page).to have_content(course.title) }
    end
  end

  context 'Administrator' do
    before do
      sign_in(create(:administrator))
      visit courses_path
    end

    it 'can see list of courses' do
      courses.each { |course| expect(page).to have_content(course.title) }
    end
  end

  context 'Course Master' do
    before do
      sign_in(create(:course_master))
      visit courses_path
    end

    it 'can see list of courses' do
      courses.each { |course| expect(page).to have_content(course.title) }
    end
  end
end
