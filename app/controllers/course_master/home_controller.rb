class CourseMaster::HomeController < CourseMaster::BaseController
  def index
    @courses = current_user.courses
    @unverified_quest_solutions = PassageSolution.unverified_for_auditor(current_user, :quests).count
  end
end
