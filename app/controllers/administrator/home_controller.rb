class Administrator::HomeController < Administrator::BaseController
  before_action :set_users, only: :index

  def index; end

  protected

  def set_users
    @users = User.all
  end
end
