require_relative '../../features_helper'

feature 'Author of lesson create material', %q{
  As author of lesson
  I can create material
  so that I can demarcate the subthemes of the lesson
} do
  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { author.lessons.last }

  context 'when author of lesson' do
    before do
      sign_in(author)
      visit edit_course_master_lesson_path(lesson)
      click_on 'Materials'
      click_on 'New Material'
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:material) }

      scenario 'can create material', js: true do
        fill_in 'Title', with: attributes[:title]
        fill_editor 'Body', with: attributes[:body]
        click_on 'Create Material'
        expect(page).to have_content('Success')
        expect(page).to have_content('Edit Material')
      end
    end # conetx 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create material', js: true do
        fill_in 'Title', with: nil
        fill_editor 'Body', with: nil
        fill_in 'Order', with: ' '
        click_on 'Create Material'

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
      visit new_course_master_lesson_material_path(lesson)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Create Material')
    end
  end
end
