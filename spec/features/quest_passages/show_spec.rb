require_relative '../features_helper'

feature 'Show quest_passage page', %q{
  As student
  I can view quest_passage page
  so that I can passage it
} do

  given(:quest_passage) { create(:quest_passage) }
  given(:course_passage) { quest_passage.lesson_passage.course_passage }
  given(:lesson) { quest_passage.lesson_passage.lesson }
  given(:owner) { course_passage.educable }
  given(:params) do
    { course_passage_id: course_passage, id: quest_passage }
  end

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(owner)
        visit course_passage_quest_passage_path(course_passage, quest_passage)
      end

      scenario 'see quest details' do
        %i(title description).each do |field|
          expect(page).to have_content(quest_passage.quest.send field)
        end

        quest_passage.quest.body_html_text.each do |text|
          expect(page).to have_content(text)
        end
      end

      scenario 'can back to lesson_passage page' do
        click_on 'Back'
        expect(page).to have_content(lesson.title)
        expect(page).to have_content(lesson.ideas)
      end
    end

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit course_passage_quest_passage_path(course_passage, quest_passage)
      end

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end

      scenario 'no see quest details' do
        %i(title description body).each do |field|
          expect(page).to_not have_content(quest_passage.quest.send field)
        end
      end
    end
  end

  context 'when not authenticated user' do
    before  do
      visit course_passage_quest_passage_path(course_passage, quest_passage)
    end

    scenario 'see sign in page' do
      expect(page).to have_button('Log in')
    end

    scenario 'no see quest details' do
      %i(title description body).each do |field|
        expect(page).to_not have_content(quest_passage.quest.send field)
      end
    end
  end
end
