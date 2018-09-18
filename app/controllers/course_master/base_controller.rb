class CourseMaster::BaseController < ApplicationController
  before_action :require_manage_courses_abilities
  
  layout 'course_master'

  respond_to :html, only: %i(index new edit show)
  respond_to :json, only: %i(destroy create update used unused index)
  before_action :verify_requested_format!

  breadcrumb 'course_master.manage_courses', :course_master_path,
                                             match: :exact,
                                             only: %i(index edit new show)

  protected

  def require_manage_courses_abilities
    authorize! :manage_courses, current_user
  end
end
