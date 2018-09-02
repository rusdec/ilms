class CourseMaster::QuestsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest, only: %i(edit update destroy)
  before_action :require_author_abilities, only: %i(edit update destroy)
  before_action :set_quest_form, only: %i(edit update destroy)
  before_action :set_new_quest_form, only: %i(new create)

  def new; end

  def edit; end

  def create
    @quest_form.create(params)
    json_response_by_result(
      { with_location: :edit_course_master_quest_url,
        without_object: true,
        with_flash: true },
      @quest_form.quest
    )
  end

  def update
    @quest_form.update(params)
    json_response_by_result({ with_serializer: QuestFormSerializer }, @quest_form)
  end

  def destroy
    @quest_form.destroy
    json_response_by_result(with_serializer: QuestSerializer)
  end

  protected

  def require_author_abilities
    authorize! :author, @quest
  end

  def set_new_quest_form
    lesson = Lesson.find(params[:lesson_id])
    @quest_form =
      QuestForm.new(current_user.quests.new(lesson: lesson).decorate)
  end

  def set_quest_form
    @quest_form = QuestForm.new(@quest.decorate)
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end
end
