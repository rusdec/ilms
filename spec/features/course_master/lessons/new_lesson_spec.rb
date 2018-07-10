require_relative '../../features_helper'

feature 'New lesson', %q{
  As user
  I can create lesson for course
  so that I can structure my course
} do

  given(:user) { create(:course_master) }
  given(:course) { create(:course, :with_lesson, author: user) }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_course_path(course)
      click_on 'Add lesson'
    end

    context 'with valid data' do
      let(:parent_lesson) { course.lessons.last }
      let(:lesson) { attributes_for(:lesson) }

      scenario 'can create new lesson', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: lesson[:title]
        fill_in 'Ideas', with: lesson[:ideas]
        fill_in 'Summary', with: lesson[:summary]
        fill_in 'Check yourself', with: lesson[:check_yourself]
        select parent_lesson.title, from: 'lesson[parent_id]'
        click_on 'Create Lesson'

        ['Add quest', 'Quests', 'Success', lesson[:title],
         lesson[:ideas], lesson[:summary]
        ].each { |text| expect(page).to have_content(text) }
      end # scenario 'can create new lesson'
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: ''
        click_on 'Create Lesson'

        ['Title can\'t be blank', 'Title is too short'].each do |error|
          expect(page).to have_content(error)
        end
      end
    end
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_course_path(course)
    end

    scenario 'redirect to root' do
      expect(page).to_not have_content('New lesson')
      expect(page).to_not have_content(/^Create$/)
    end
  end
end
