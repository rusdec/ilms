require_relative '../features_helper'

feature 'Show course', %q{
  As User
  I can view a course page
  so that I can see details of course
} do

  let(:user) { UserDecorator.decorate(create(:user)) }
  let!(:course) do
    CourseDecorator.decorate(
      create(:course, :with_lessons, author: create(:course_master))
    )
  end
  
  before do
    sign_in(user)
    visit course_path(course)
  end

  scenario 'see details of course ' do
  end

  scenario 'see lessons of course' do
    expect(page).to have_content('Lessons')
    course.lessons.each { |lesson| expect(page).to have_content(lesson.title) }
  end
end
