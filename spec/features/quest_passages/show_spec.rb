require_relative '../features_helper'

feature 'Show lesson_passage page', %q{
  As student
  I can view lesson materials
  so that I can learn it
} do

  given(:user) { create(:course_master, :with_full_course) }
  given(:course_passage) { user.course_passages.last }
  given!(:quest_passage) { course_passage.lesson_passages.first.quest_passages.last }
  given(:quest) { quest_passage.quest }
  given(:lesson) { course_passage.lesson_passages.first.lesson }
  given(:params) do
    { course_passage_id: course_passage, id: quest_passage }
  end

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit course_passage_quest_path(course_passage, quest_passage)
      end

      scenario 'see quest details' do
        %i(title description).each do |field|
          expect(page).to have_content(quest.send field)
        end

        quest.body_html_text.each { |text| expect(page).to have_content(text) }
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
        visit course_passage_quest_path(course_passage, quest_passage)
      end

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end

      scenario 'no see quest details' do
        %i(title description body).each do |field|
          expect(page).to_not have_content(quest.send field)
        end
      end
    end
  end

  context 'when not authenticated user' do
    before  do
      visit course_passage_quest_path(course_passage, quest_passage)
    end

    scenario 'see sign in page' do
      expect(page).to have_button('Log in')
    end

    scenario 'no see quest details' do
      %i(title description body).each do |field|
        expect(page).to_not have_content(quest.send field)
      end
    end
  end
end
