class Administrator::BaseController < ApplicationController
  before_action :require_admin_panel_abilities

  protected

  def require_admin_panel_abilities
    unless can? :admin_panel, current_user
      redirect_to root_path, alert: 'Access denied'
    end
  end
end
