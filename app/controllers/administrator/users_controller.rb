class Administrator::UsersController < Administrator::BaseController
  before_action :set_users, only: :index
  before_action :set_user, only: %i(show update)

  include JsonResponsed

  def index; end

  def show; end

  def update
    respond_to do |format|
      format.json do
        @user.update(user_params)
        json_response_by_result(with_serializer: UserSerializer)
      end
    end
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
