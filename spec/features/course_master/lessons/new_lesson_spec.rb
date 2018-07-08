require_relative '../../features_helper'

feature 'New lesson', %q{
  As user
  I can create lesson for course
  so that I can structure my course
} do

  given(:user) { create(:course_master) }
  given(:course) { create(:course, author: user) }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_course_path(course)
      click_on 'Add lesson'
    end

    context 'with valid data' do
      let(:lesson) { attributes_for(:lesson) }

      scenario 'can create new lesson', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: lesson[:title]
        fill_in 'Ideas', with: lesson[:ideas]
        fill_in 'Summary', with: lesson[:summary]
        fill_in 'Check yourself', with: lesson[:check_yourself]
        click_on 'Create lesson'

        ['Add quest',
         'Quests',
         'Success',
         lesson[:title],
         lesson[:ideas],
         lesson[:summary]
        ].each do |text|
          expect(page).to have_content(text)
        end
      end # scenario 'can create new lesson'
    end # context 'with valid data'

    context 'with invalid data' do
      scenario 'see errors', js: true do
        expect(page).to have_content('New lesson')

        fill_in 'Title', with: ''
        click_on 'Create lesson'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Title is too short')
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
