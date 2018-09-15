class CourseMaster::BadgesController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_badge, only: %i(update edit destroy)
  before_action :require_author_abilities, only: %i(update edit destroy)
  before_action :set_badgable, only: %i(create new)

  def index
    @badges = BadgeDecorator.decorate_collection(current_user.created_badges)
  end

  def new
    @badge = current_user.created_badges.new(
      badgable: @badgable, course: @badgable.course
    ).decorate
  end

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

  def edit
    @badge = BadgeDecorator.decorate(@badge)
  end

  def update
    @badge.update(badge_params)
    json_response_by_result({ with_serializer: BadgeSerializer })
  end

  def destroy
    @badge.destroy
    json_response_by_result(with_serializer: BadgeSerializer)
  end

  protected

  def require_author_abilities
    authorize! :author, @badge
  end

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:title, :description, :image)
  end

  def set_badgable
    @badgable = badgable_class.find(params[badgable_id_param])
  end

  def badgable_class
    badgable_id_param[0...-3].classify.constantize
  end

  def badgable_id_param
    params.keys.select { |key| key[-3..-1] == '_id' }[0]
  end
end
