class CourseMaster::BaseController < ApplicationController
  before_action :require_manage_courses_abilities

  respond_to :html, only: %i(index new edit show)
  respond_to :json, only: %i(destroy create update used unused)
  before_action :verify_requested_format!

  protected

  def require_manage_courses_abilities
    authorize! :manage_courses, current_user
  end
end
