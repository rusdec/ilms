require_relative '../features_helper'

feature 'Start learning', %q{
  As user
  I can start learning course
  so that I can learn something new
} do

  given!(:user) { create(:user) }
  given(:author) { create(:course_master) }
  given!(:course) { create(:course, :full, author: author) }

  context 'when authenticated user' do
    before { sign_in(user) }
    
    context 'when not in the process of studying the course' do
      before { visit course_path(course) }

      scenario 'see Learn now! link' do
        expect(page).to have_button('Learn now!')
      end

      scenario 'can start learning course', js: true do
        click_on('Learn now!')

        Capybara.using_wait_time(5) do
          expect(page).to have_content('Success')
          course.lessons.each do |lesson|
            expect(page).to have_content(lesson.title)
          end
        end
      end
    end # context 'when not in the process of studying the course'

    context 'when in the process of studying the course' do
      before do
        create(:passage, user: user, passable: course)
        visit course_path(course)
      end

      scenario 'no see Learn now! button' do
        expect(page).to_not have_button('Learn now!')
      end

      scenario 'see You learning it button' do
        expect(page).to have_content('You learning it')
      end
    end # context 'when in the process of studying the course'
  end

  context 'when not authenticated user' do
    before { visit course_path(course) }

    scenario 'can\'t see Learn_now! button' do
      expect(page).to_not have_button('Learn now!')
    end
  end
end
