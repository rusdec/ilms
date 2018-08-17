class CourseMaster::BadgesController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_badge, only: %i(show update edit destroy)
  before_action :require_author_abilities, only: %i(show update edit destroy)

  def index
    @badges = BadgeDecorator.decorate_collection(current_user.created_badges)
  end

  def new
    @badge = current_user.created_badges.new
  end

  def create
    @badge = current_user.created_badges.create(badge_params)
    json_response_by_result(
      with_serializer: BadgeSerializer,
      with_location: :course_master_badges_path,
      without_object: true,
      with_flash: true
    )
  end

  def show; end

  def edit; end

  def update
    @badge.update(badge_params)
    json_response_by_result({ with_serializer: BadgeSerializer })
  end

  def destroy
    @badge.destroy
    json_response_by_result(
      with_location: :course_master_badges_path,
      without_object: true,
      with_flash: true
    )
  end

  protected

  def require_author_abilities
    authorize! :author, @badge
  end

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:title, :description)
  end
end
