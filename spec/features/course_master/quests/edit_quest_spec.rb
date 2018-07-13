require_relative '../../features_helper'

feature 'Edit quest', %q{
  As author of quest
  I can update quest
  so that I can change quest detail data
} do
  given!(:user) { create(:course_master, :with_course_and_lesson_and_quest) }
  given(:quest) { user.quests.last }

  context 'when author' do
    before do
      sign_in(user)
      visit edit_course_master_quest_path(quest)
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:updated_quest) }

      scenario 'can update quest', js: true do
        expect(page).to have_content('Edit quest')

        fill_in 'Title', with: attributes[:title]
        fill_in 'Description', with: attributes[:description]
        click_on 'Update Quest'

        expect(page).to have_content('Success')
      end
    end # context  'with valid data'

    context 'with invalid data' do
      scenario 'can\'t update quest', js: true do
        fill_in 'Title', with: nil
        fill_in 'Description', with: nil
        click_on 'Update Quest'

        expect(page).to_not have_content('Success')
        ['Title can\'t be blank',
         'Title is too short',
         'Description can\'t be blank',
         'Description is too short'].each do |error|
          expect(page).to have_content(error)
         end
      end
    end # context 'with invalid data'
  end # context 'when author'

  context 'when not author' do
    scenario 'can\'t create quest' do
      [create(:user), create(:course_master)].each do |user|
        sign_in(user)
        visit edit_course_master_quest_path(quest)

        expect(page).to have_content('Access denied')
        expect(page).to_not have_content('Update Quest')
        sign_out
      end
    end # scenario 'can\'t create quest'
  end # context 'when not author'
end
