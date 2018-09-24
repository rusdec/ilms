require_relative '../../features_helper'

feature 'Author destory material', %q{
  As author of lesson
  I can see lesson's materials
  so that I cat choose which quest will remove or edit or somethink else
} do

  given!(:user) { create(:course_master) }
  given!(:lesson) { create(:lesson, author: user) }
  given!(:materials) { create_list(:material, 3, author: user, lesson: lesson) }

  context 'when author' do
    before do
      sign_in(user)
      visit edit_course_master_lesson_path(lesson, locale: I18n.locale)
    end

    scenario 'can see material' do
      expect(page).to have_content('Materials')
      expect(page).to have_link('New material')

      within '.material-items' do
        expect(page).to have_content('Order')
        expect(page).to have_content('Title')
        expect(page).to have_content('Created at')
        expect(page).to have_content('Actions')
      end

      lesson.materials.each do |material|
        expect(page).to have_link(material.decorate.title_preview)
        expect(page).to have_content(material.decorate.created_at)
      end
    end

    it_behaves_like 'having_remote_links' do
      given(:resources) { lesson.materials }
      given(:container) { '.material-items' }
    end
  end
end 
