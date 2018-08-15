class CourseMaster::CoursesController < CourseMaster::BaseController
  before_action :set_courses, only: :index
  before_action :set_course, only: %i(update edit destroy show)
  before_action :require_author_of_course, only: %i(edit destroy update)

  include JsonResponsed

  def index; end

  def create
    @course = current_user.courses.create(course_params)
    json_response_by_result(with_location: :course_master_course_url,
                            with_flash: true)
  end

  def edit; end

  def show
    @course = CourseDecorator.decorate(@course)
  end

  def new
    @course = current_user.courses.new
  end

  def destroy
    @course.destroy
    json_response_by_result(with_location: :course_master_courses_url,
                            without_object: true,
                            with_flash: true)
  end

  def update
    @course.update(course_params)
    json_response_by_result
  end

  protected

  def require_author_of_course
    authorize! :author, @course
  end

  def set_courses
    @courses = current_user.courses
  end

  def course_params
    params.require(:course).permit(:title, :decoration_description, :level)
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
