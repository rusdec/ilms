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
        click_on 'verify'
      end

      scenario 'can accept quest solution', js: true do
        expect(page).to_not have_content('Solution (Accepted)')
        expect(page).to have_content('Solution (Unverified)')

        click_on 'Accept'

        expect(page).to have_content('Success')
        expect(page).to have_content('Solution (Accepted)')
        expect(page).to_not have_content('Solution (Unverified)')
      end

      scenario 'can decline quest solution', js: true do
        expect(page).to_not have_content('Solution (Declined)')
        expect(page).to have_content('Solution (Unverified)')

        click_on 'Decline'

        expect(page).to have_content('Success')
        expect(page).to have_content('Solution (Declined)')
        expect(page).to_not have_content('Solution (Unverified)')
      end

      scenario 'can back to quest solutions page' do
        click_on 'Back'

        expect(page).to_not have_content('Accept')
        expect(page).to_not have_content('Decline')
        expect(page).to have_content('Quest solutions')
      end
    end

    context 'when not author of course' do
      before { visit course_master_quest_solutions_path }

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end
    end
  end
end
