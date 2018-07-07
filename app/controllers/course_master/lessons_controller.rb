class CourseMaster::LessonsController < CourseMaster::BaseController
  before_action :set_course, only: %i(index new create)
  before_action :set_lesson, only: %i(show destroy)
  before_action :require_author_of_course, only: %i(new create)
  before_action :require_author_of_lesson, only: %i(destroy)

  include JsonResponsed

  def index
    @lessons = @course.lessons
  end

  def show; end

  def new
    @lesson = @course.lessons.new(author: current_user)
  end

  def create
    respond_to do |format|
      format.json do
        create_lesson
        json_response_by_result(
          object: @lesson, location: :course_master_lesson_url, with_flash: true
        )
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        @lesson.destroy
        json_response_by_result(
          { with_location: :course_master_course_lessons_url, with_flash: true },
          @lesson.course
        )
      end
    end
  end

  protected

  def require_author_of_course
    authorize! :author, @course
  end

  def require_author_of_lesson
    authorize! :author, @lesson
  end

  def set_course
    @course = Course.find(params[:course_id])
  end


  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(
      :title, :order, :ideas, :summary, :check_yourself
    )
  end

  def create_lesson
    @lesson = @course.lessons.create(lesson_params.merge(user_id: current_user.id))
  end
end
