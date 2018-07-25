require_relative '../../features_helper'

feature 'Show quest solutions', %q{
  As Course master
  I can view detail quest solution
  so that I can accept or decline it
} do


  given(:quest_solution) { create(:quest_solution) }
  given(:auditor) { quest_solution.quest_passage.quest.author }

  context 'when authenticated user' do
    context 'when author of course' do
      before do
        sign_in(auditor)
        visit course_master_quest_solutions_path
      end

      context 'when not verified' do
        before { click_on 'verify' }

        scenario 'can accept quest solution', js: true do
          expect(page).to_not have_content('Solution (accepted)')
          expect(page).to have_content('Solution (unverified)')

          click_on 'Accept'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content('Success')
          expect(page).to have_content('Solution (accepted)')
          expect(page).to_not have_content('Solution (unverified)')
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end

        scenario 'can decline quest solution', js: true do
          expect(page).to_not have_content('Solution (declined)')
          expect(page).to have_content('Solution (unverified)')

          click_on 'Decline'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content('Success')
          expect(page).to have_content('Solution (declined)')
          expect(page).to_not have_content('Solution (unverified)')
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end

        scenario 'can back to quest solutions page' do
          click_on 'Back'

          expect(page).to_not have_content('Accept')
          expect(page).to_not have_content('Decline')
          expect(page).to have_content('Quest solutions')
        end
      end # context 'when not verified'

      context 'when verified' do
        before do
          quest_solution.accept!
          click_on 'verify'
        end

        scenario 'no see accept/decline buttons' do
          expect(page).to_not have_button('Accept')
          expect(page).to_not have_button('Decline')
        end
      end
    end # context 'when author of course'

    context 'when not author of course' do
      before { visit course_master_quest_solutions_path }

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end
    end
  end
end
