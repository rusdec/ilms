class CourseMaster::HomeController < CourseMaster::BaseController
  def index
    @courses = current_user.courses
  end
end
