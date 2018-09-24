require_relative '../../features_helper'

feature 'Destory quest', %q{
  As author of quest
  I can delete quest
  so that I no one had any access to it
} do

  given!(:user) { create(:course_master, :with_course_and_lesson_and_quest) }
  given(:quest) { user.quests.last }

  context 'when author' do
    before do
      sign_in(user)
      visit edit_course_master_lesson_path(quest.lesson, locale: I18n.locale)
    end

    scenario 'can delete course', js: true do
      within ".quest-item[data-id='#{quest.id}']" do
        click_destory_remote_link
      end

      Capybara.using_wait_time(5) do
        expect(page).to have_content('Success')
        expect(page).to_not have_content(quest.title)
      end
    end
  end
end 
