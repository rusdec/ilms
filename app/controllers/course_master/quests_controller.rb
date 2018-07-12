class CourseMaster::QuestsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest, only: %i(edit show update destroy)
  before_action :require_author_abilities, only: %i(edit update destroy)

  respond_to :html, only: %i(index new edit show)
  respond_to :json, only: %i(destroy create update used unused)
  before_action :verify_requested_format!

  def index
    @quests = current_user.quests
  end

  def unused
    @quests = current_user.quests.unused
    json_response_by_result({ with_serializer: QuestSerializer }, @quests)
  end

  def used
    @quests = current_user.quests.used
    json_response_by_result({ with_serializer: QuestSerializer }, @quests)
  end

  def new
    @quest = current_user.quests.new
  end

  def edit; end

  def create
    @quest = current_user.quests.create(quest_params)
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
    json_response_by_result(with_location: :course_master_quests_url,
                            with_flash: true,
                            without_object: true)
  end

  protected

  def require_author_abilities
    authorize! :author, @quest
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def quest_params
    params.require(:quest).permit(:title, :description, :level)
  end
end
