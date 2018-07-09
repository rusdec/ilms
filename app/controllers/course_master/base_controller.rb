class CourseMaster::BaseController < ApplicationController
  before_action :require_manage_courses_abilities

  protected

  def require_manage_courses_abilities
    authorize! :manage_courses, current_user
  end
end
