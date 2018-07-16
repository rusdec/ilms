class CourseMaster::QuestsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest, only: %i(edit show update destroy)
  before_action :set_quest_form, only: %i(edit show update destroy)
  before_action :set_new_quest_form, only: %i(new create)
  before_action :require_author_abilities, only: %i(edit update destroy)

  respond_to :html, only: %i(index new edit show)
  respond_to :json, only: %i(destroy create update used unused)
  before_action :verify_requested_format!

  def index
    @quests = current_user.quests
  end

  def new; end

  def edit; end

  def create
    @quest_form.create(params)
    json_response_by_result({ with_location: :course_master_quest_url,
                            with_flash: true,
                            without_object: true },
                            @quest_form.quest)
  end

  def show; end

  def update
    @quest_form.update(params)
    json_response_by_result({ with_serializer: QuestFormSerializer }, @quest_form)
  end

  def destroy
    @quest_form.destroy
    json_response_by_result({ with_location: :course_master_lesson_url,
                              location_object: @quest_form.lesson,
                              with_flash: true,
                              without_object: true },
                              @quest_form.quest)
  end

  protected

  def require_author_abilities
    authorize! :author, @quest_form.quest
  end

  def set_new_quest_form
    lesson = Lesson.find(params[:lesson_id])
    @quest_form = QuestForm.new(current_user.quests.new(lesson: lesson))
  end

  def set_quest_form
    @quest_form = QuestForm.new(@quest)
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end
end
