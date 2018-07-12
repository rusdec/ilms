class CourseMaster::HomeController < CourseMaster::BaseController
  def index
    @courses = current_user.courses
    @quests = current_user.quests
  end
end
