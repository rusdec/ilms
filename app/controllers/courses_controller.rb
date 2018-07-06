class CoursesController < ApplicationController
  before_action :set_courses, only: :index
  before_action :set_course, only: :show

  def index; end

  def show; end

  protected

  def set_courses
    @courses = Course.all
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
