require_relative '../features_helper'

feature 'Create quest_solution', %q{
  As student
  I can create quest solution
  so that I can complete lesson
} do

  given!(:quest_passage) { create(:quest_passage) }
  given(:course_passage) { quest_passage.lesson_passage.course_passage }
  given(:owner) { course_passage.educable }
  given(:params) do
    { course_passage_id: course_passage, id: quest_passage }
  end

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before { sign_in(owner) }

      context 'when have not unverified solution' do
        before do
          visit course_passage_quest_passage_path(course_passage, quest_passage)
        end

        context 'when valid data' do
          scenario 'can create quest solution', js: true do
            fill_editor 'Body', with: attributes_for(:quest_solution)[:body]
            click_on 'Create Quest solution'

            expect(page).to have_content('Success')
          end

          scenario 'can\'t create more then one quest solution', js: true do
            fill_editor 'Body', with: attributes_for(:quest_solution)[:body]
            click_on 'Create Quest solution'

            expect(page).to_not have_button('Create Quest solution')
            expect(page).to have_content(
              'Waiting for verification of your solution...'
            )
          end
        end

        context 'when invalid data' do
          scenario 'see error', js: true do
            fill_editor 'Body', with: nil
            click_on 'Create Quest solution'

            expect(page).to have_content('Body can\'t be blank')
          end
        end
      end # context 'when have not unverified solution'

      context 'when have unverified solution' do
        before do
          create(:quest_solution, quest_passage: quest_passage)
          visit course_passage_quest_passage_path(course_passage, quest_passage)
        end

        scenario 'can\'t create quest_solution' do
          expect(page).to_not have_button('Create Quest solution')
          expect(page).to have_content('Waiting for verification of your solution...')
        end
      end
    end # context 'when owner of course_passage'

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit course_passage_quest_passage_path(course_passage, quest_passage)
      end

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end

      scenario 'no see Create Quest solution link' do
        expect(page).to_not have_link('Create Quest solution')
      end
    end
  end

  context 'when not authenticated user' do
    before do
      visit course_passage_quest_passage_path(course_passage, quest_passage)
    end

    scenario 'see sign in page' do
      expect(page).to have_button('Log in')
    end
  end
end
