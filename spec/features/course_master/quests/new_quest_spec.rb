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
      visit edit_course_master_lesson_path(lesson, locale: I18n.locale)
      click_on 'Quests'
      click_on 'New quest'
    end

    scenario 'see breadcrumb' do
      within '.breadcrumb' do
        expect(page).to have_link('Manage courses')
        expect(page).to have_link('Courses')
        expect(page).to have_link(lesson.decorate.title_preview)
        expect(page).to have_link(lesson.course.decorate.title_preview)
        expect(page).to have_content('New quest')
      end
    end

    context 'with valid data' do
      given(:attributes) { attributes_for(:quest) }
      before do
        fill_in 'Title', with: attributes[:title]
        fill_in 'Description', with: attributes[:description]
        fill_editor 'Body', with: attributes[:body]
        select('5', from: 'Difficulty')
      end

      context 'when alternative quest changed to none' do
        scenario 'can create quest', js: true do
          expect(page).to have_content('New quest')
          expect(page).to have_content('none')

          choose id: 'quest_quest_group_id'
          click_on 'Create'

          expect(page).to have_content('Success')
          expect(page).to have_content('Edit quest')
        end
      end # context 'when alternative quest changed to none'
      
      context 'when changed alternative quest' do
        scenario 'can create quest', js: true do
          expect(page).to have_content('New quest')

          choose option: default_quest.id
          click_on 'Create'

          expect(page).to have_content('Success')
          expect(page).to have_content('Edit quest')
        end
      end # context 'when changed alternative quest'
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'can\'t create quest', js: true do
        fill_in 'Title', with: nil
        fill_in 'Description', with: nil
        fill_editor 'Body', with: nil
        click_on 'Create'

        Capybara.using_wait_time(5) do
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
    end
  end # context 'when CourseMaster'

  context 'when User' do
    before do
      sign_in(create(:user))
      visit new_course_master_lesson_quest_path(lesson, locale: I18n.locale)
    end

    scenario 'can\'t create quest' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content('Create')
    end
  end
end
