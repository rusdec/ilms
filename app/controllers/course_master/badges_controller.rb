class CourseMaster::BadgesController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_badge, only: %i(update edit destroy)
  before_action :require_author_abilities, only: %i(update edit destroy)
  before_action :set_badgable, only: %i(create new)
  before_action :set_new_badge, only: :new

  breadcrumb 'course_master.courses', :course_master_courses_path,
                                      match: :exact,
                                      only: %i(index edit new)

  before_action :set_breadcrumb_chain, only: %i(edit new)
  before_action :decorate_badge, only: %i(edit new)

  def index
    @course = Course.find(params[:course_id])
    authorize! :author, @course
    breadcrumb @course.decorate.title_preview,
               edit_course_master_course_path(@course)
    breadcrumb 'course_master.badges', course_master_courses_path
    @badges = BadgeDecorator.decorate_collection(@course.badges)
  end

  def new; end

  def create
    authorize! :author, @badgable
    @badge = current_user.created_badges.create(
      badge_params.merge(badgable: @badgable, course: @badgable.course)
    )

    json_response_by_result(
      with_serializer: BadgeSerializer,
      with_location: :edit_course_master_badge_path,
      without_object: true,
      with_flash: true
    )
  end

  def edit; end

  def update
    @badge.update(badge_params)
    json_response_by_result({ with_serializer: BadgeSerializer })
  end

  def destroy
    @badge.destroy
    json_response_by_result(with_serializer: BadgeSerializer)
  end

  protected

  def set_breadcrumb_chain
    send "set_breadcrumb_chain_#{@badge.badgable.class.to_s.underscore}",
         @badge.badgable
  end

  def set_breadcrumb_chain_course(course)
    breadcrumb course.decorate.title_preview, edit_course_master_course_path(course)
    set_breadcrumb_badge
  end

  def set_breadcrumb_chain_quest(quest)
    breadcrumb quest.course.decorate.title_preview,
               edit_course_master_course_path(quest.course)
    breadcrumb 'course_master.lessons',
               course_master_course_lessons_path(quest.course)
    breadcrumb quest.lesson.decorate.title_preview,
               course_master_lesson_path(quest.lesson)
    set_breadcrumb_badge
  end

  def set_breadcrumb_badge
    breadcrumb 'course_master.badges', course_master_course_badges_path(@badge.course)
    if @badge.persisted?
      breadcrumb @badge.title, edit_course_master_badge_path(@badge)
    else
      breadcrumb 'course_master.new_badge', ''
    end
  end

  def require_author_abilities
    authorize! :author, @badge
  end

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def set_new_badge
    @badge = current_user.created_badges.new(
      badgable: @badgable, course: @badgable.course
    )
  end

  def badge_params
    params.require(:badge).permit(:title, :description, :image, :hidden)
  end

  def set_badgable
    @badgable = badgable_class.find(params[badgable_id_param])
  end

  def decorate_badge
    @badge = @badge.decorate
  end

  def badgable_class
    badgable_id_param[0...-3].classify.constantize
  end

  def badgable_id_param
    params.keys.select { |key| key[-3..-1] == '_id' }[0]
  end
end
