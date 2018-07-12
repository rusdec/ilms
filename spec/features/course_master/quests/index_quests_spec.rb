require_relative '../../features_helper'

feature 'Quests page', %q{
  As Course Master
  I can see list of my quests
  so that I can click on any for detail
} do
  
  
  context 'when CourseMaster' do
    given!(:user) { create(:course_master, :with_quests) }
    before do
      sign_in(user)
      visit course_master_quests_path
    end

    scenario 'see own quests' do
      expect(page).to have_content('Quests')
      user.quests.each { |quest| expect(page).to have_link(quest.title) }
    end

    scenario 'no see another quests' do
      create(:course_master, :with_quests).quests do |another_quest|
        expect(page).to have_not(another_quest.title)
      end
    end

    scenario 'see create quest link' do
      expect(page).to have_link('Create Quest')
    end
  end

  context 'when User' do
    before do
      sign_in(create(:user))
      visit course_master_quests_path
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end
