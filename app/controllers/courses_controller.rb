class CoursesController < ApplicationController
  include Passaged

  before_action :set_courses, only: :index
  before_action :set_course, only: :show

  def index; end

  def show
    @course_passage = @course.course_passages.new
  end

  protected

  def set_courses
    @courses = Course.all
  end

  def set_course
    @course = CourseDecorator.decorate(Course.find(params[:id]))
  end
end
