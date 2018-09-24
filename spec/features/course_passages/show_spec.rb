require_relative '../features_helper'

feature 'Course passage page', %q{
  As user
  I can view list of available lessons
  so that I can take lesson to learn
} do

  given!(:user) { create(:user) }
  given(:author) { create(:course_master) }
  given!(:course) { create(:course, :full, author: author) }
  given!(:course_passage) do
    create(:passage, passable: course, user: user)
    CoursePassage.first
  end
  
  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit passage_path(course_passage, locale: I18n.locale)
      end

      scenario 'see breadcrubm' do
        within '.breadcrumb' do
          expect(page).to have_link('My courses')
          expect(page).to have_content(course.title)
        end
      end

      scenario 'see list of lesson passages' do
        passages = LessonPassageDecorator.decorate_collection(course_passage.lesson_passages)
        within '.row-lessons' do
          passages.each do |passage|
            expect(page).to have_content(passage.passable.title)
            expect(page).to have_content('In progress')
            expect(page).to have_content(passage.td_required_quests)
          end
        end
      end

      scenario 'see links for availabled lessons and text for unavailabled' do
        course_passage.lesson_passages.each do |passage|
          if passage.unavailable?
            expect(page).to have_content(passage.passable.title)
          else
            expect(page).to have_link(passage.passable.title)
          end
        end
      end

      context 'Tab Statistics' do
        before { click_on 'Statistic' }

        scenario 'see collected badges' do
          create(:badge, badgable: course, course: course, author: course.author)
          create(:badge, badgable: course.quests.last, course: course, author: course.author)

          refresh

          within '.row-collected-badges' do
            course.badges.each do |badge|
              expect(page).to have_content(badge.title)
              expect(page).to have_content("Number of awarded: #{badge.rewarders.count}")
            end
          end
        end

        scenario 'see common progress' do
          expect(page).to have_content('Common progress')
          within '.row-common-progress' do
            expect(page).to have_content('0 from 2')
            expect(page).to have_content('0 from 6')
            expect(page).to have_content('0 from 0', count: 2)
            expect(page).to have_content('Hidden badges')
            expect(page).to have_content('Badges')
            expect(page).to have_content('Lessons')
            expect(page).to have_content('Quests')
          end 
        end

      end # context 'Tab Statistics' do
    end # context 'when owner of course_passage' 

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit passage_path(course_passage, locale: I18n.locale)
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
    before { visit passage_path(course_passage, locale: I18n.locale) }

    scenario 'see sign in page' do
      expect(page).to have_content('You need to sign in or sign up before continuing')
      expect(page).to have_button('Log in')
    end
  end
end
