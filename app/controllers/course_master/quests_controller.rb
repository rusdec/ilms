class CourseMaster::QuestsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest, only: %i(edit show update destroy)
  before_action :set_lesson, only: %i(create new)
  before_action :require_author_abilities, only: %i(edit update destroy)

  respond_to :html, only: %i(index new edit show)
  respond_to :json, only: %i(destroy create update used unused)
  before_action :verify_requested_format!

  def index
    @quests = current_user.quests
  end

  def new
    @quest = current_user.quests.new(lesson: @lesson)
  end

  def edit; end

  def create
    @quest = current_user.quests.create(quest_params.merge(lesson: @lesson))
    json_response_by_result(with_location: :course_master_quest_url,
                            with_flash: true,
                            without_object: true)
  end

  def show; end

  def update
    @quest.update(quest_params)
    json_response_by_result(with_serializer: QuestSerializer)
  end

  def destroy
    @quest.destroy
    json_response_by_result({ with_location: :course_master_lesson_url,
                              with_flash: true,
                              without_object: true },
                            @quest.lesson)
  end

  protected

  def require_author_abilities
    authorize! :author, @quest
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def quest_params
    params.require(:quest).permit(:title, :description, :level)
  end
end
