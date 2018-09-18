class CourseMaster::MaterialsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_lesson, only: %i(new create)
  before_action :set_new_material, only: %i(new create)
  before_action :require_lesson_author_abilities, only: %i(new create)

  before_action :set_material, only: %i(edit update destroy)
  before_action :require_material_author_abilities, only: %i(edit update destroy)

  breadcrumb 'course_master.courses', :course_master_courses_path,
                                      match: :exact,
                                      only: %i(index edit new)

  before_action :set_breadcrumb_chain, only: %i(new edit)

  def new; end

  def edit; end

  def create
    @material.assign_attributes(material_params)
    @material.save
    json_response_by_result(
      with_location: :edit_course_master_material_url,
      without_object: true,
      with_flash: true
    )
  end

  def update
    @material.update(material_params)
    json_response_by_result
  end

  def destroy
    @material.destroy
    json_response_by_result
  end

  private

  def set_breadcrumb_chain
    [@material.lesson.course, @material.lesson].each do |crumb|
      breadcrumb crumb.decorate.title_preview,
                 polymorphic_path([:edit, :course_master, crumb])
    end

    if @material.persisted?
      breadcrumb @material.title, edit_course_master_material_path(@material)
    else
      breadcrumb 'course_master.new_material', ''
    end
  end

  def require_material_author_abilities
    authorize! :author, @material
  end

  def require_lesson_author_abilities
    authorize! :author, @lesson
  end

  def set_new_material
    @material = current_user.materials.new(lesson: @lesson)
  end

  def set_material
    @material = Material.find(params[:id])
  end

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def material_params
    params.require(:material).permit(:title, :body, :summary, :order)
  end
end
