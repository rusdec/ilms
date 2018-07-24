require_relative '../features_helper'

feature 'Course passage page', %q{
  As user
  I can view list of available lessons
  so that I can take lesson to learn
} do

  let(:course) { create(:course_master, :with_course_and_lessons).courses.last }
  let(:user) { create(:user) }
  let!(:course_passage) { create(:course_passage, course: course, educable: user) }
  
  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit course_passage_path(course_passage)
      end

      scenario 'see lessons of course' do
        course.lessons.each do |lesson|
          expect(page).to have_content(lesson.title)
        end
      end

      scenario 'see lessons availabled for learning' do
        expect(page).to have_link(course.lessons.first.title)
      end
    end 

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit course_passage_path(course_passage)
      end

      scenario 'no see lessons and see error' do
        expect(page).to have_content('Access denied')
        course.lessons.each do |lesson|
          expect(page).to_not have_content(lesson.title)
        end
      end
    end
  end

  context 'when not authenticated user' do
    before { visit course_passage_path(course_passage) }

    scenario 'see sign in page' do
      expect(page).to have_content('You need to sign in or sign up before continuing')
      expect(page).to have_button('Log in')
    end
  end
end
