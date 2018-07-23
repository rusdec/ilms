module CourseMaster::QuestSolutionsHelper
  def quest_solution_table_status(quest_solution)
    if quest_solution.verified? && quest_solution.passed?
      tag.span 'Accepted', class: 'badge badge-success'
    elsif quest_solution.verified? && !quest_solution.passed?
      tag.span 'Declined', class: 'badge badge-danger'
    else
      tag.span 'Unverified', class: 'badge badge-default'
    end
  end

  def quest_solution_status(quest_solution)
    if quest_solution.verified? && quest_solution.passed?
      'Accepted'
    elsif quest_solution.verified? && !quest_solution.passed?
      'Declined'
    else
      'Unverified'
    end
  end
end
