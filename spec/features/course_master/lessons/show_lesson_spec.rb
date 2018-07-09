require_relative '../../features_helper'

feature 'Show lesson', %q{
  As user
  I can view lesson show page
  so that I see lesson details
} do

  given(:user) { create(:course_master) }
  given(:lesson) { create(:course, :with_lesson, author: user).lessons.last }

  context 'when author' do
    before do
      sign_in(user)
      visit course_master_lesson_path(lesson)
    end

    scenario 'see lesson detail' do
      [lesson[:title],
       lesson[:ideas],
       lesson[:summary]
      ].each { |text| expect(page).to have_content(text) }
    end

    scenario 'see remote links' do
      %w(Edit Delete).each { |link| expect(page).to have_link(link) }
    end

    scenario 'see add quest link' do
      expect(page).to have_link('Add quest')
    end

    scenario 'see back to course link' do
      expect(page).to have_link('Back to course')
    end

    scenario 'see add material link' do
      expect(page).to have_link('Add material')
    end
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_lesson_path(lesson)
    end

    scenario 'no see remote links' do
      %w(Edit Delete).each { |link| expect(page).to_not have_link(link) }
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
