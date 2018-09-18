class CourseMaster::QuestsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest, only: %i(edit update destroy)
  before_action :require_author_abilities, only: %i(edit update destroy)
  before_action :set_quest_form, only: %i(edit update destroy)
  before_action :set_new_quest_form, only: %i(new create)

  breadcrumb 'course_master.courses', :course_master_courses_path,
                                      match: :exact,
                                      only: %i(index edit new)

  before_action :set_breadcrumb_chain, only: %i(new edit)

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

  def set_breadcrumb_chain
    [@quest_form.quest.lesson.course, @quest_form.quest.lesson].each do |crumb|
      breadcrumb crumb.decorate.title_preview,
                 polymorphic_path([:edit, :course_master, crumb])
    end

    if @quest_form.persisted?
      breadcrumb @quest_form.title, edit_course_master_quest_path(@quest_form.quest)
    else
      breadcrumb 'course_master.new_quest', ''
    end
  end

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
