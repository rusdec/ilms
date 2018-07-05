class CoursesController < ApplicationController
  before_action :set_courses, only: :index

  def index; end

  protected

  def set_courses
    @courses = Course.all
  end
end
