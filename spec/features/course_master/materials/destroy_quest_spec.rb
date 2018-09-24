require_relative '../../features_helper'

feature 'Author destory material', %q{
  As author of material
  I can delete material
  so that I no one had any access to it
} do

  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:material) { author.lessons.last.materials.last }

  context 'when author' do
    before do
      sign_in(author)
      visit edit_course_master_lesson_path(material.lesson, locale: I18n.locale)
    end

    scenario 'can delete material', js: true do
      within ".material-item[data-id='#{material.id}']" do
        click_destory_remote_link
      end

      expect(page).to have_content('Success')
      expect(page).to_not have_content(material.title)
    end
  end
end 
