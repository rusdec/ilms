require_relative '../features_helper'

feature 'Show lesson_passage page', %q{
  As student
  I can view lesson materials
  so that I can learn it
} do

  given(:user) { create(:course_master, :with_full_course) }
  given(:course_passage) { user.course_passages.last }
  given(:lesson_passage) { course_passage.lesson_passages.first }
  given!(:quest_passage) { lesson_passage.quest_passages.last }
  given(:quest) { quest_passage.quest_group.quests.last }
  given(:lesson) { lesson_passage.lesson }
  given(:params) do
    { course_passage_id: course_passage,
      quest_passage_id: quest_passage,
      quest_id: quest }
  end

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit course_passage_quest_path(course_passage, quest_passage, quest)
      end

      scenario 'see quest details' do
        %i(title description).each do |field|
          expect(page).to have_content(quest.send field)
        end

        quest.body_html_text.each { |text| expect(page).to have_content(text) }
      end

      scenario 'can back to lesson_passage page' do
        click_on 'Back'
        expect(page).to have_content(lesson_passage.lesson.title)
        expect(page).to have_content(lesson_passage.lesson.ideas)
      end
    end

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit course_passage_quest_path(course_passage, quest_passage, quest)
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
      visit course_passage_quest_path(course_passage, quest_passage, quest)
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
