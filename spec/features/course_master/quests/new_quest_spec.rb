require_relative '../../features_helper'

feature 'New quest', %q{
  As CourseMaster
  I can create new quest
  so that I can use it in the future
} do
  given(:user) { create(:course_master, :with_course_and_lesson_and_quest) }
  given(:lesson) { user.lessons.last }
  given!(:default_quest) { lesson.quests.last }

  context 'when CourseMaster' do
    before do
      sign_in(user)
      visit new_course_master_lesson_quest_path(lesson)
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:quest) }
      before do
        fill_in 'Title', with: attributes[:title]
        fill_in 'Description', with: attributes[:description]
        fill_editor 'Body', with: attributes[:body]
      end

      context 'when alternative quest changed to none' do
        scenario 'can create quest', js: true do
          expect(page).to have_content('New quest')
          expect(page).to have_content('none')

          choose id: 'quest_quest_group_id'
          click_on 'Create Quest'

          expect(page).to have_content('Success')
          expect(page).to have_content(attributes[:title])
          expect(page).to have_content(attributes[:body])
          expect(page).to have_content(attributes[:description])
          expect(page).to_not have_link(default_quest.title)
          expect(page).to_not have_link(attributes[:title])
        end
      end
      
      context 'when changed alternative quest' do
        scenario 'can create quest', js: true do
          expect(page).to have_content('New quest')

          choose option: default_quest.id
          click_on 'Create Quest'

          expect(page).to have_content('Success')
          expect(page).to have_content(attributes[:title])
          expect(page).to have_content(attributes[:body])
          expect(page).to have_content(attributes[:description])
          expect(page).to have_link(default_quest.title)
          expect(page).to_not have_link(attributes[:title])
        end
      end
    end

    context 'with invalid data' do
      scenario 'can\'t create quest', js: true do
        fill_in 'Title', with: nil
        fill_in 'Description', with: nil
        fill_editor 'Body', with: nil
        click_on 'Create Quest'

        expect(page).to_not have_content('Success')
        ['Title can\'t be blank',
         'Title is too short',
         'Description can\'t be blank',
         'Description is too short',
         'Body can\'t be blank',
         'Body is too short'].each do |error|
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
