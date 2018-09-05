require_relative '../features_helper'

feature 'Show user knowledges', %q{
  As user
  I can open own profile courses page
  so that I can continue my studies
} do

  given!(:user) { create(:user) }
  before do
    course = create(:course, :full, author: create(:course_master))
    create(:passage, passable: course, user: user)
  end

  context 'when authenticated user' do
    before { sign_in(user) }
    context 'and user visit own profile page' do
      before do
        visit user_path(user)
        click_on 'My Courses'
      end
      
      scenario 'see progress data' do
        passage = CoursePassageDecorator.decorate(user.passages.first)
        expect(page).to have_content("#{passage.passed_lesson_passages_percent}%")
        expect(page).to have_content(passage.created_at)
        expect(page).to have_content(passage.status.name)
      end

      scenario 'see own course passages' do
        user.passages.for_courses.each do |course_passage|
          expect(page).to have_link(course_passage.passable.title)
        end
      end
    end # context 'and user visit own profile page'

    context 'and user visit foreign profile page' do
      before { visit user_path(create(:user)) }
      expect(page).to_not have_link('My Courses')
    end # context 'and user visit foreign profile page'
  end

  context 'when not authenticated user' do
    scenario 'can\'t see my courses link' do
      expect(page).to_not have_link('My courses')
    end
  end
end
