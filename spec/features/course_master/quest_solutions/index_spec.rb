require_relative '../../features_helper'

feature 'View quest solutions', %q{
  As Course master
  I can view quest solutions for my courses
  so that I can see its
} do


  given(:quest_passage) { create(:quest_passage, :with_solutions) }
  given(:quest_solutions) { quest_passage.quest_solutions }
  given(:auditor) { quest_solutions.last.quest_passage.quest.author }

  context 'when authenticated user' do
    context 'when author of course' do
      before do
        sign_in(auditor)
        visit course_master_quest_solutions_path
      end

      scenario 'see quest solutons list' do
        expect(page).to have_link('verify', count: quest_solutions.count)

        quest_solutions.each do |quest_solution|
          [
            quest_solution.quest_passage.lesson_passage.educable.full_name,
            quest_solution.quest_passage.lesson_passage.lesson.title.truncate(30),
            quest_solution.quest_passage.lesson_passage.lesson.course.title.truncate(30),
            quest_solution.quest_passage.quest.title.truncate(30),
            format_date(quest_solution.created_at)
          ].each { |field| expect(page).to have_content(field) }
        end
      end
    end

    context 'when not author of course' do
      before { visit course_master_quest_solutions_path }

      scenario 'see error' do
        expect(page).to have_content('Access denied')
      end
    end
  end
end
