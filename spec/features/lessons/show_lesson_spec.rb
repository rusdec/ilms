require_relative '../features_helper'

feature 'Show lesson', %q{
  As User
  I can view lesson page
  so that I see lesson details
} do

  given(:user) { create(:course_master) }
  given(:lesson) { create(:course, :with_lesson, author: user).lessons.last }

  context 'when author' do
    before do
      sign_in(create(:user))
      visit lesson_path(lesson)
    end

    scenario 'see lesson detail' do
      [lesson[:title],
       lesson[:ideas],
      ].each do |text|
        expect(page).to have_content(text)
      end
    end

    scenario 'no see some lessons detail information' do
      ['Quests',
       lesson[:summary],
       lesson[:check_yourself]
      ].each do |info|
        expect(page).to_not have_content(info)
      end
    end

    scenario 'see lessons materias' do
      expect(page).to have_content('Materials')
    end

    scenario 'no see remote links' do
      expect(page).to_not have_link('Edit')
      expect(page).to_not have_link('Delete')
    end

    scenario 'no see add quest link' do
      expect(page).to_not have_link('Add quest')
    end

    scenario 'no see add material link' do
      expect(page).to_not have_link('Add material')
    end

    scenario 'see back to course link' do
      expect(page).to have_link('Back to course')
    end
  end
end
