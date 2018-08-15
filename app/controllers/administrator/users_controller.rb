class Administrator::UsersController < Administrator::BaseController
  before_action :set_users, only: :index
  before_action :set_user, only: %i(show update)

  include JsonResponsed

  respond_to :json, only: :update
  before_action :verify_requested_format!

  def index
    @users = UserDecorator.decorate_collection(@users)
  end

  def show
    @user = UserDecorator.decorate(@user)
  end

  def update
    @user.update(user_params)
    json_response_by_result(with_serializer: UserSerializer)
  end

  protected

  def set_users
    @users = User.all
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:type)
  end
end
