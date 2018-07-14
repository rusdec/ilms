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

  def edit
    @lesson = @quest.lesson
  end

  def create
    @quest = QuestForm.new.create(params.merge(user: current_user))
    json_response_by_result(with_location: :course_master_quest_url,
                            with_flash: true,
                            without_object: true)
  end

  def show; end

  def update
    @quest = QuestForm.new(quest: @quest).update(params)
    json_response_by_result(with_serializer: QuestSerializer)
  end

  def destroy
    @quest = QuestForm.new(quest: @quest).destroy
    json_response_by_result({ with_location: :course_master_lesson_url,
                              with_flash: true,
                              without_object: true },
                            @quest.lesson)
  end

  protected

  def update_quest
    ActiveRecord::Base.transaction do
      params = quest_params
      params[:quest_group_id] ||= create_group
      @quest.update!(params)
    end
  end

  def create_group
    @lesson.quest_groups.create!
  end

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
    params.require(:quest).permit(:title, :description, :level, :quest_group_id)
  end
end
