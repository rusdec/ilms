class UsersController < ApplicationController
  layout 'profile'

  include JsonResponsed

  before_action :authenticate_user!

  before_action :set_user, only: %i(
    update show show_badges show_knowledges show_courses
  )
  before_action :set_statistic, only: %i(show show_knowledges show_courses)
  before_action :decorate_user, only: %i(show show_badges show_knowledges show_courses)

  def show
    gon.statistic = {
      courses_progress: @statistic.courses_progress,
      lessons_progress: @statistic.lessons_progress,
      quests_progress: @statistic.quests_progress,
      badges_progress: @statistic.badges_progress,
      top_three_knowledges: @statistic.top_three_knowledges
    }
  end

  def show_courses
    authorize! :edit_profile, @user.object
    @passages = CoursePassageDecorator.decorate_collection(@user.passages.for_courses)
  end

  def show_knowledges
    gon.statistic = { knowledges_directions: @statistic.knowledges_directions }
  end

  def show_badges; end

  def update
    authorize! :edit_profile, @user

    respond_to do |format|
      format.json do
        if password_params[:password].present?
          @user.update_with_password(user_params.merge(password_params))
          bypass_sign_in(@user)
        else
          @user.update(user_params)
        end
        json_response_by_result(with_serializer: UserSerializer)
      end
    end
  end

  protected

  def set_statistic
    @statistic = UserStatistic.new(@user)
  end

  def decorate_user
    @user = @user.decorate
  end

  def set_user
    @user = User.find(params[:id])
    gon.profile_user = @user
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :avatar, :remove_avatar)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
