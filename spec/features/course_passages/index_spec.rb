require_relative '../features_helper'

feature 'Course passages page', %q{
  As user
  I can see own current course passages
  so that I can continue my studies
} do

  given!(:user) { create(:user) }
  before do
    course = create(:course, :full, author: create(:course_master))
    create(:passage, passable: course, user: user)
  end

  context 'when authenticated user' do
    before { sign_in(user) }
    
    scenario 'see my courses link' do
      expect(page).to have_link('My courses')
    end

    scenario 'see own course passages' do
      click_on 'My courses'
      user.passages.for_courses.each do |course_passage|
        expect(page).to have_link(course_passage.passable.title)
      end
    end
  end

  context 'when not authenticated user' do
    scenario 'can\'t see my courses link' do
      expect(page).to_not have_link('My courses')
    end
  end
end
