require_relative '../features_helper'

feature 'Course passage page', %q{
  As user
  I can view list of available lessons
  so that I can take lesson to learn
} do

  given!(:user) { create(:user) }
  given(:author) { create(:course_master) }
  given!(:course) { create(:course, :full, author: author) }
  given!(:course_passage) { create(:passage, passable: course, user: user) }
  
  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit passage_path(course_passage)
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
        visit passage_path(course_passage)
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
    before { visit passage_path(course_passage) }

    scenario 'see sign in page' do
      expect(page).to have_content('You need to sign in or sign up before continuing')
      expect(page).to have_button('Log in')
    end
  end
end
