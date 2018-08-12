require_relative '../features_helper'

feature 'Create passage_solution', %q{
  As student
  I can create quest solution
  so that I can complete lesson
} do

  given!(:course) { create(:course, :full) }
  given!(:owner) { create(:user) }
  before { create(:passage, passable: course, user: owner) }
  given(:passage) { Passage.for_quests.first }
  given(:params) { { id: passage } }

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before { sign_in(owner) }

      context 'when have not unverified solution' do
        before do
          visit passage_path(passage)
        end

        context 'when valid data' do
          scenario 'can create quest solution', js: true do
            fill_editor 'Body', with: attributes_for(:passage_solution)[:body]
            click_on 'Create Passage solution'

            expect(page).to have_content('Success')
          end

          scenario 'can\'t create more then one quest solution', js: true do
            fill_editor 'Body', with: attributes_for(:passage_solution)[:body]
            click_on 'Create Passage solution'

            expect(page).to_not have_button('Create Passage solution')
            expect(page).to have_content(
              'Waiting for verification of your solution...'
            )
          end
        end

        context 'when invalid data' do
          scenario 'see error', js: true do
            fill_editor 'Body', with: nil
            click_on 'Create Passage solution'

            expect(page).to have_content('Body can\'t be blank')
          end
        end
      end # context 'when have not unverified solution'

      context 'when have unverified solution' do
        before do
          create(:passage_solution, passage: passage)
          visit passage_path(passage)
        end

        scenario 'can\'t create passage_solution' do
          expect(page).to_not have_button('Create Passage solution')
          expect(page).to have_content('Waiting for verification of your solution...')
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

      scenario 'no see Create Passage solution link' do
        expect(page).to_not have_link('Create Passage solution')
      end
    end
  end

  context 'when not authenticated user' do
    before do
      visit passage_path(passage)
    end

    scenario 'see sign in page' do
      expect(page).to have_button('Log in')
    end
  end
end
