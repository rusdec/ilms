class Administrator::BaseController < ApplicationController
  before_action :require_admin_panel_abilities

  breadcrumb 'administrator.administration', :administrator_path, match: :exact

  protected

  def require_admin_panel_abilities
    authorize! :admin_panel, current_user
  end
end
