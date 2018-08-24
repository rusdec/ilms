class CourseMaster::MaterialsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_lesson, only: %i(new create)
  before_action :set_new_material, only: %i(new create)
  before_action :require_lesson_author_abilities, only: %i(new create)

  before_action :set_material, only: %i(edit update destroy)
  before_action :require_material_author_abilities, only: %i(edit update destroy)

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
