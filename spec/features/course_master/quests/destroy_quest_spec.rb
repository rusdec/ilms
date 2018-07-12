require_relative '../../features_helper'

feature 'Destory quest', %q{
  As author of quest
  I can delete quest
  so that I no one had any access to it
} do

  given!(:user) { create(:course_master, :with_quest) }
  given(:quest) { user.quests.last }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_quest_path(quest)
    end

    scenario 'can delete course', js: true do
      click_on 'Delete'

      expect(page).to have_content('Success')
      expect(page).to_not have_content(quest.title)
    end
  end
end 
