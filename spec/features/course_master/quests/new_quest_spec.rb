require_relative '../../features_helper'

feature 'New quest', %q{
  As CourseMaster
  I can create new quest
  so that I can use it in the future
} do
  given(:user) { create(:course_master, :with_course_and_lesson) }
  given(:lesson) { user.lessons.last }

  context 'when CourseMaster' do
    before do
      sign_in(user)
      visit new_course_master_lesson_quest_path(lesson)
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:quest) }

      scenario 'can create quest', js: true do
        expect(page).to have_content('New quest')

        fill_in 'Title', with: attributes[:title]
        fill_in 'Description', with: attributes[:description]
        click_on 'Create Quest'

        expect(page).to have_content('Success')
        expect(page).to have_content(attributes[:title])
        expect(page).to have_content(attributes[:description])
      end
    end

    context 'with invalid data' do
      scenario 'can\'t create quest', js: true do
        fill_in 'Title', with: nil
        fill_in 'Description', with: nil
        click_on 'Create Quest'

        expect(page).to_not have_content('Success')
        ['Title can\'t be blank',
         'Title is too short',
         'Description can\'t be blank',
         'Description is too short'].each do |error|
          expect(page).to have_content(error)
         end
      end
    end
  end # context 'when CourseMaster'

  context 'when User' do
    before do
      sign_in(create(:user))
      visit new_course_master_lesson_quest_path(lesson)
    end

    scenario 'can\'t create quest' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Create Quest')
    end
  end
end
