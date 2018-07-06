class CourseMaster::LessonsController < CourseMaster::BaseController
  before_action :set_course, only: %i(index new)
  before_action :set_lesson, only: :show
  before_action :require_author_of_course, only: %i(new)

  include JsonResponsed

  def index
    @lessons = @course.lessons
  end

  def show; end

  def new
    @lesson = @course.lessons.new(author: current_user)
  end

  protected

  def require_author_of_course
    authorize! :author, @course
  end

  def set_course
    @course = Course.find(params[:course_id])
  end


  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
end
