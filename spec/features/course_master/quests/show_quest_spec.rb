require_relative '../../features_helper'

feature 'Show quest', %q{
  As any CourseMaster
  I can view quest page
  so that I can see quests detail
} do
  given!(:user) { create(:course_master, :with_course_and_lesson_and_quest) }
  given(:quest) { user.quests.last }

  context 'when author' do
    before do
      sign_in(user)
      create(:quest, lesson: quest.lesson,
                     author: quest.author,
                     title: 'OtherQuestTitle',
                     quest_group: quest.quest_group)
      visit course_master_quest_path(quest)
    end

    scenario 'can see details' do
      [quest.title, quest.description, quest.level].each do |text|
        expect(page).to have_content(text)
      end
    end

    scenario 'no see link to self in section of alternative quests' do
      expect(page).to_not have_link(quest.title)
      expect(page).to have_link('OtherQuestTitle')
    end

    scenario 'can see remote links' do
      %w(Edit Delete).each { |link| expect(page).to have_link(link) }
    end
  end # context 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_quest_path(quest)
    end

    scenario 'can see details' do
      [quest.title, quest.description, quest.level].each do |text|
        expect(page).to have_content(text)
      end
    end

    scenario 'can\'t see remote links' do
      %w(Edit Delete).each { |link| expect(page).to_not have_link(link) }
    end
  end # context 'when not author'

  context 'when User' do
    before do
      sign_in(create(:user))
      visit course_master_quest_path(quest)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end
