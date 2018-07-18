require_relative '../features_helper'

feature 'Course passages page', %q{
  As user
  I can see own current course passages
  so that I can continue my studies
} do

  let(:courses) { create(:course_master, :with_course_and_lessons).courses }
  let(:user) { create(:user) }
  before do
    courses.each do |course|
      create(:course_passage, educable: user, course: course)
    end
  end
  
  context 'when authenticated user' do
    before { sign_in(user) }
    
    scenario 'see my courses link' do
      expect(page).to have_link('My courses')
    end

    scenario 'see own course passages' do
      click_on 'My courses'
      user.course_passages.each do |course_passage|
        expect(page).to have_link(course_passage.course.title)
      end
    end
  end

  context 'when not authenticated user' do
    scenario 'can\'t see my courses link' do
      expect(page).to_not have_link('My courses')
    end
  end
end
