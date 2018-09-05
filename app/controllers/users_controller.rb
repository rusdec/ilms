class UsersController < ApplicationController
  include JsonResponsed

  layout 'profile'

  respond_to :json, only: :update
  respond_to :html, only: %i(show show_badges show_knowledges show_courses)
  before_action :authenticate_user!

  before_action :verify_requested_format!
  before_action :set_user, only: %i(show update show_badges show_knowledges show_courses)
  before_action :decorate_user, only: %i(show show_badges show_knowledges show_courses)

  def show; end

  def show_courses
    authorize! :edit_profile, @user.object
    @passages = CoursePassageDecorator.decorate_collection(@user.passages.for_courses)
  end

  def show_knowledges; end

  def show_badges; end

  def update
    authorize! :edit_profile, @user

    if password_params[:password].present?
      @user.update_with_password(user_params.merge(password_params))
      bypass_sign_in(@user)
    else
      @user.update(user_params)
    end
    json_response_by_result(with_serializer: UserSerializer)
  end

  protected

  def decorate_user
    @user = @user.decorate
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :avatar, :remove_avatar)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
