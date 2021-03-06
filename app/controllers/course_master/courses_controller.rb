class CourseMaster::CoursesController < CourseMaster::BaseController
  before_action :set_course, only: %i(update edit destroy show)
  before_action :require_author_of_course, only: %i(edit destroy update)

  breadcrumb 'course_master.courses', :course_master_courses_path,
                                      match: :exact,
                                      only: %i(index edit new)

  before_action :decorate_course, only: %i(edit show)

  include JsonResponsed

  def index
    @courses = CourseDecorator.decorate_collection(current_user.courses)
  end

  def create
    @course = current_user.courses.create(course_params)
    json_response_by_result(with_location: :edit_course_master_course_url,
                            without_object: true,
                            with_flash: true)
  end

  def edit
    breadcrumb @course.title, course_master_course_path(@course)
  end

  def show; end

  def new
    breadcrumb 'course_master.new_course', ''
    @course = current_user.courses.new.decorate
  end

  def destroy
    @course.destroy
    json_response_by_result(with_serializer: CourseSerializer)
  end

  def update
    @course.update(course_params)
    json_response_by_result(with_serializer: CourseFormSerializer)
  end

  protected

  def decorate_course
    @course = @course.decorate
  end

  def require_author_of_course
    authorize! :author, @course
  end

  def course_params
    params.require(:course).permit(
      :title, :decoration_description, :published,
      :difficulty, :short_description, :image, :remove_image,
      course_knowledges_attributes: [:id, :knowledge_id,
                                     :_destroy, :percent,
                                     knowledge_attributes: [:name,
                                                            :knowledge_direction_id]]
    )
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
