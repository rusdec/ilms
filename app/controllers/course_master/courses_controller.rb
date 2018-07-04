class CourseMaster::CoursesController < CourseMaster::BaseController
  before_action :set_courses, only: :index
  before_action :set_course, only: %i(update edit destroy)

  include JsonResponsed

  skip_authorize_resource only: %(update edit destroy)

  def index; end

  def create
    @course = current_user.courses.create(course_params)
    json_response_by_result(object: @course)
  end

  def edit
    authorize! :author_of_course, @course
  end

  def destroy
    authorize! :author_of_course, @course
    @course.destroy
    json_response_by_result
  end

  def update
    authorize! :author_of_course, @course
    @course.update(course_params)
    json_response_by_result(object: @course)
  end

  protected

  def set_courses
    @courses = Course.all
  end

  def course_params
    params.require(:course).permit(:title, :decoration_description, :level)
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
