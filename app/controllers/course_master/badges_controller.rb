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
    @badges = BadgeDecorator.decorate_collection(current_user.created_badges)
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
    breadcrumb course.decorate.title_preview,
               polymorphic_path([:edit, :course_master, course])
    set_breadcrumb_badge
  end

  def set_breadcrumb_chain_quest(quest)
    [quest.course, quest.lesson].each do |crumb|
      breadcrumb crumb.decorate.title_preview,
                 polymorphic_path([:edit, :course_master, crumb])
    end
    set_breadcrumb_badge
  end

  def set_breadcrumb_badge
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
    params.require(:badge).permit(:title, :description, :image)
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
