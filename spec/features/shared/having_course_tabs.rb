shared_examples_for 'having_course_tabs' do
  scenario 'see tabs' do
    within '#mainPageTab' do
      expect(page).to have_link('Course')
      expect(page).to have_link('Lessons')
      expect(page).to have_link('Badges')
      expect(page).to have_link('Statistic')
    end
  end
end
