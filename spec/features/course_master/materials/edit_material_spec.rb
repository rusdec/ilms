require_relative '../../features_helper'

feature 'Author of lesson update material', %q{
  As author of lesson
  I can update material
  so that I can change it details
} do
  given(:author) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { author.lessons.last }
  given(:material) { lesson.materials.last }

  context 'when author of lesson' do
    before do
      sign_in(author)
      visit edit_course_master_lesson_path(lesson, locale: I18n.locale)
      within ".material-item[data-id='#{material.id}']" do
        click_edit_remote_link
      end
    end

    scenario 'see breadcrumb' do
      within '.breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        expect(page).to have_link(lesson.course.decorate.title_preview)
        expect(page).to have_link('Lessons')
        expect(page).to have_link(lesson.decorate.title_preview)
        expect(page).to have_content(material.title)
      end
    end

    scenario 'can back to materials' do
      click_on 'Back to materials'
      expect(page).to have_content('Edit lesson')
      lesson.materials.each do |material|
        expect(page).to have_content(material.title)
      end
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:material) }

      scenario 'can update material', js: true do
        fill_in 'Title', with: attributes[:title]
        fill_editor 'Body', with: attributes[:body]
        click_on 'Save'

        expect(page).to have_content('Success')
      end
    end # conetx 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create material', js: true do
        fill_in 'Title', with: nil
        fill_editor 'Body', with: nil
        fill_in 'Order', with: nil
        click_on 'Save'


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
      visit edit_course_master_material_path(material, locale: I18n.locale)
    end

    scenario 'redirect to root' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_link('Save')
    end
  end
end
