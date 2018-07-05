class CourseMaster::CoursesController < CourseMaster::BaseController
  before_action :set_courses, only: :index
  before_action :set_course, only: %i(update edit destroy show)
  before_action :require_author_of_course, only: %i(edit destroy update)

  include JsonResponsed

  skip_authorize_resource only: %(update edit destroy new)

  def index; end

  def create
    @course = current_user.courses.create(course_params)
    json_response_by_result(object: @course)
  end

  def edit
    authorize! :author_of_course, @course
  end

  def show; end

  def new
    @course = current_user.courses.new
  end

  def destroy
    @course.destroy
    json_response_by_result
  end

  def update
    @course.update(course_params)
    json_response_by_result(object: @course)
  end

  protected

  def require_author_of_course
    authorize! :author_of_course, @course
  end

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
