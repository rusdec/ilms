class CourseMaster::HomeController < CourseMaster::BaseController
  def index
    @courses = current_user.courses
    @unverified_quest_solutions = QuestSolution.unverifieds_for_auditor(current_user).count
  end
end
