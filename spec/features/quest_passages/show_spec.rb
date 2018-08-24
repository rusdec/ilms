require_relative '../features_helper'

feature 'Show quest_passage page', %q{
  As student
  I can view quest_passage page
  so that I can passage it
} do

  given!(:course) { create(:course, :full) }
  given!(:owner) { create(:user) }
  before { create(:passage, passable: course, user: owner) }
  given(:passage) { Passage.for_quests.first.decorate }
  given(:lesson) { passage.passable.lesson }
  given(:params) { { id: passage } }

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(owner)
        visit passage_path(passage)
      end

      scenario 'see quest details' do
        %i(title description).each do |field|
          expect(page).to have_content(passage.passable.send field)
        end

        expect(page).to have_content(passage.passable.body_text)
      end

      scenario 'can back to parent(lesson) passage page' do
        click_on 'Back'
        expect(page).to have_content(lesson.title)
        expect(page).to have_content(lesson.ideas)
      end

      scenario 'see own declined quest solutions' do
        solution = create(:passage_solution, passage: passage)
        solution.declined!
        refresh

        passage.solutions.all_declined.each do |solution|
          expect(page).to have_content('Declined solutions')
          expect(page).to have_content(solution.decorate.body_html)
        end
      end

      context 'when have not decline quest solutions' do
        scenario 'no see title Declined solutions' do
          expect(page).to_not have_content('Declined solutions')
        end
      end
    end # context 'when owner of course_passage'

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit passage_path(passage)
      end

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end

      scenario 'no see quest details' do
        %i(title description body).each do |field|
          expect(page).to_not have_content(passage.passable.send field)
        end
      end
    end # context 'when not owner of course_passage'
  end

  context 'when not authenticated user' do
    before  do
      visit passage_path(passage)
    end

    scenario 'see sign in page' do
      expect(page).to have_button('Log in')
    end

    scenario 'no see quest details' do
      %i(title description body).each do |field|
        expect(page).to_not have_content(passage.passable.send field)
      end
    end
  end # context 'when authenticated user'
end
