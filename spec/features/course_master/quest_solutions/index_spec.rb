require_relative '../../features_helper'

feature 'View quest solutions', %q{
  As Course master
  I can view quest solutions for my courses
  so that I can see its
} do


  given!(:auditor) { create(:course_master) }
  given!(:course) { create(:course, :full, author: auditor) }
  before do
    create(:passage, passable: course)
    create(:passage_solution, passage: Passage.for_quests.last)
    create(:passage_solution, passage: Passage.for_quests.first)
  end
  given(:passage_solutions) { PassageSolution.all }

  context 'when authenticated user' do
    context 'when author of course' do
      before do
        sign_in(auditor)
        visit course_master_solutions_path
      end

      scenario 'see quest solutons list' do
        expect(page).to have_link('verify', count: passage_solutions.count)

        passage_solutions.each do |passage_solution|
          passable = passage_solution.passage.passable
          [
            passage_solution.passage.user.full_name,
            passable.title.truncate(30),
            passable.lesson.title.truncate(30),
            passable.lesson.course.title.truncate(30),
            format_date(passage_solution.created_at)
          ].each { |field| expect(page).to have_content(field) }
        end
      end
    end

    context 'when not author of course' do
      before { visit course_master_solutions_path }

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end
    end
  end
end
