require_relative '../../features_helper'

feature 'Lessons author create material', %q{
  As lessons author
  I can create material
  so that I can demarcate the subthemes of the lesson
} do
  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { author.lessons.last }

  context 'when author of lesson' do
    before do
      sign_in(author)
      visit course_master_lesson_path(lesson)
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:material) }

      scenario 'can create material', js: true do
        click_on 'Add material'

        fill_in 'Title', with: attributes[:title]
        fill_in 'Body', with: attributes[:body]
        click_on 'Create Material'

        expect(page).to have_content('Success')
        expect(page).to have_content(attributes[:title])
      end
    end # conetx 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create material', js: true do
        click_on 'Add material'

        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        fill_in 'Order', with: nil
        click_on 'Create Material'

        [ 'Title can\'t be blank',
          'Title is too short',
          'Body can\'t be blank',
          'Body is too short',
          'Order is not a number'
        ].each { |error| expect(page).to have_content(error) }
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
      expect(page).to_not have_content('Create Lesson')
    end
  end
end
