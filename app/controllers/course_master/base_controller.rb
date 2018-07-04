class CourseMaster::BaseController < ApplicationController
  before_action :require_manage_courses_abilities

  protected

  def require_manage_courses_abilities
    unless can? :manage_courses, current_user
      redirect_to root_path, alert: 'Access denied'
    end
  end
end
