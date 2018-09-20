class CourseMaster::LessonsController < CourseMaster::BaseController
  before_action :set_course, only: %i(new create index)
  before_action :set_new_lesson, only: :new
  before_action :set_lesson, only: %i(show destroy update edit)
  before_action :set_persisted_lessons, only: %i(new edit)
  before_action :require_author_of_course, only: %i(new create index)
  before_action :require_author_of_lesson, only: %i(destroy update edit)

  breadcrumb 'course_master.courses', :course_master_courses_path,
                                      match: :exact,
                                      only: %i(index edit new)

  before_action :set_breadcrumb_chain, only: %i(new edit)
  before_action :decorate_lesson, only: %i(edit new)

  include JsonResponsed

  def index
    breadcrumb @course.decorate.title_preview, edit_course_master_course_path(@course)
    breadcrumb 'lessons', course_master_course_lessons_path(@course)
    @lessons = LessonDecorator.decorate_collection(
      @course.lessons.roots_and_descendants_preordered
    )
  end

  def edit; end

  def new; end

  def update
    @lesson.update(lesson_params)
    json_response_by_result
  end

  def create
    create_lesson
    json_response_by_result(
      with_location: :edit_course_master_lesson_url,
      without_object: true,
      with_flash: true
    )
  end

  def destroy
    @lesson.destroy
    json_response_by_result
  end

  protected

  def decorate_lesson
    @lesson = @lesson.decorate
  end

  # For edit, new
  def set_breadcrumb_chain
    breadcrumb @lesson.course.decorate.title_preview,
               edit_course_master_course_path(@lesson.course), match: :exact

    breadcrumb 'lessons', course_master_course_lessons_path(@course || @lesson.course), match: :exact

    if @lesson.persisted?
      breadcrumb @lesson.title,
        edit_course_master_lesson_path(@lesson), match: :exact
    else
      breadcrumb 'course_master.new_lesson', ''
    end
  end

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

  def set_new_lesson
    @lesson = @course.lessons.new
  end

  def set_persisted_lessons
    @lessons = @lesson.course.lessons.persisted
  end

  def lesson_params
    params.require(:lesson).permit(:title, :ideas, :summary, :difficulty,
                                   :check_yourself, :parent_id)
  end

  def create_lesson
    @lesson = @course.lessons.create(lesson_params.merge(user_id: current_user.id))
  end
end
