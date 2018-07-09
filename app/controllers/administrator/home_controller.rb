class Administrator::HomeController < Administrator::BaseController
  before_action :set_users_count, only: :index

  def index; end

  protected

  def set_users_count
    @users_count = User.count
  end
end
