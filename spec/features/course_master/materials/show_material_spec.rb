require_relative '../../features_helper'

feature 'Show material', %q{
  As any CourseMaster
  I can view material page
  so that I can see materials detail
} do
  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { author.lessons.last }
  given(:material) { lesson.materials.last }


  context 'when author of material' do
    before do
      sign_in(author)
      visit course_master_material_path(material)
    end

    scenario 'can see details' do
      %w(title body summary order).each do |field|
        expect(page).to have_content(material.send field)
      end
    end

    scenario 'can see remote links' do
      %w(Edit Delete).each { |link| expect(page).to have_link(link) }
    end
  end # context 'when author'

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_material_path(material)
    end

    scenario 'can see details' do
      %w(title body summary order).each do |field|
        expect(page).to have_content(material.send field)
      end
    end

    scenario 'can\'t see remote links' do
      %w(Edit Delete).each { |link| expect(page).to_not have_link(link) }
    end
  end # context 'when not author'

  context 'when User' do
    before do
      sign_in(create(:user))
      visit course_master_material_path(material)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
    end
  end
end
