class CourseMaster::LessonsController < CourseMaster::BaseController
  before_action :set_course, only: %i(index new create)
  before_action :set_lesson, only: %i(show destroy update edit)
  before_action :require_author_of_course, only: %i(new create)
  before_action :require_author_of_lesson, only: %i(destroy update edit)

  include JsonResponsed

  def index
    @lessons = @course.lessons
  end

  def edit; end

  def show; end

  def new
    @lesson = @course.lessons.new
    @lessons = @course.lessons.persisted
  end

  def update
    @lesson.update(lesson_params)
    json_response_by_result
  end

  def create
    create_lesson
    json_response_by_result(with_location: :course_master_lesson_url,
                            with_flash: true)
  end

  def destroy
    @lesson.destroy
    json_response_by_result({ with_location: :course_master_course_url,
                              location_object: @lesson.course,
                              without_object: true, with_flash: true })
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
    params.require(:lesson).permit(:title, :order, :ideas, :summary,
                                   :check_yourself, :parent_id)
  end

  def create_lesson
    @lesson = @course.lessons.create(lesson_params.merge(user_id: current_user.id))
  end
end
