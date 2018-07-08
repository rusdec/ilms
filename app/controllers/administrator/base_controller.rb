class Administrator::BaseController < ApplicationController
  before_action :require_admin_panel_abilities

  protected

  def require_admin_panel_abilities
    authorize! :admin_panel, current_user
  end
end
