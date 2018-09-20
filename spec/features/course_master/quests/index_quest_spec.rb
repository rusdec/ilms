require_relative '../../features_helper'

feature 'Destory quest', %q{
  As author of lesson
  I can see lesson's quests
  so that I cat choose which quest will remove or edit or somethink else
} do

  given!(:user) { create(:course_master) }
  given!(:lesson) { create(:lesson, author: user) }
  given!(:quests) { create_list(:quest, 3, lesson: lesson, author: user) }

  context 'when author' do
    before do
      sign_in(user)
      visit edit_course_master_lesson_path(lesson, locale: I18n.locale)
    end

    scenario 'can see quests' do
      expect(page).to have_content('Quests')
      expect(page).to have_link('New quest')

      within '.quest-items' do
        expect(page).to have_content('Difficulty')
        expect(page).to have_content('Title')
        expect(page).to have_content('Created at')
        expect(page).to have_content('Actions')
      end

      lesson.quests.each do |quest|
        expect(page).to have_link(quest.decorate.title_preview)
      end
    end

    it_behaves_like 'having_remote_links' do
      given(:resources) { lesson.quests }
      given(:container) { '.quest-items' }
    end
  end
end 
