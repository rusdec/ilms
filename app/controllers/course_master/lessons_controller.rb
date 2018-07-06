class CourseMaster::LessonsController < CourseMaster::BaseController
  before_action :set_course, only: :index
  before_action :set_lesson, only: :show

  def index
    @lessons = @course.lessons
  end

  def show; end

  protected

  def set_course
    @course = Course.find(params[:course_id])
  end


  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
end
