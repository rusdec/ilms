require_relative '../../features_helper'

feature 'Lessons author update material', %q{
  As lessons author
  I can update material
  so that I can change it details
} do
  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { author.lessons.last }
  given(:material) { lesson.materials.last }

  context 'when author of lesson' do
    before do
      sign_in(author)
      visit course_master_material_path(material)
      click_on 'Edit'
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:material) }

      scenario 'can update material', js: true do
        fill_in 'Title', with: attributes[:title]
        fill_editor 'Body', with: attributes[:body]
        click_on 'Update Material'

        expect(page).to have_content('Success')
      end
    end # conetx 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create material', js: true do
        fill_in 'Title', with: nil
        fill_editor 'Body', with: nil
        fill_in 'Order', with: nil
        click_on 'Update Material'


        Capybara.using_wait_time(5) do
          [ 'Title can\'t be blank',
            'Title is too short',
            'Body can\'t be blank',
            'Body is too short',
            'Order is not a number'
          ].each { |error| expect(page).to have_content(error) }
        end
      end
    end # context 'with valid data'
  end # context 'when author of lesson'

  context 'when not author of lesson' do
    before do
      sign_in(create(:course_master))
      visit edit_course_master_material_path(material)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Update Lesson')
    end
  end
end
