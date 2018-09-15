require_relative '../../features_helper'

feature 'Show quest solutions', %q{
  As Course master
  I can view detail quest solution
  so that I can accept or decline it
} do


  given!(:auditor) { create(:course_master) }
  before { create(:passage, passable: create(:course, :full, author: auditor)) }
  given!(:quest_solution) do
    create(:passage_solution, passage: Passage.for_quests.last)
  end

  context 'when authenticated user' do
    context 'when author of course' do
      before do
        sign_in(auditor)
        visit course_master_solutions_path
      end

      context 'when not verified' do
        before { click_on 'Verify' }

        scenario 'can accept quest solution', js: true do
          expect(page).to_not have_content('Solution (Accepted)')
          expect(page).to have_content('Solution (Unverified)')

          click_on 'Accept'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content('Success')
          expect(page).to have_content('Solution (Accepted)')
          expect(page).to_not have_content('Solution (Unverified)')
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end

        scenario 'can decline quest solution', js: true do
          expect(page).to_not have_content('Solution (Declined)')
          expect(page).to have_content('Solution (Unverified)')

          click_on 'Decline'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content('Success')
          expect(page).to have_content('Solution (Declined)')
          expect(page).to_not have_content('Solution (Unverified)')
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end

        scenario 'can back to quest solutions page' do
          click_on 'Back'

          expect(page).to_not have_content('Accept')
          expect(page).to_not have_content('Decline')
          expect(page).to have_content('Quest\'s solutions')
        end
      end # context 'when not verified'

      context 'when verified' do
        before do
          quest_solution.accepted!
          click_on 'Verify'
        end

        scenario 'no see accept/decline buttons' do
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end
      end
    end # context 'when author of course'

    context 'when not author of course' do
      before { visit course_master_solutions_path }

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end
    end
  end
end
