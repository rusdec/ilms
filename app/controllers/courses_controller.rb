class CoursesController < ApplicationController
  include Passaged

  def index
    @courses = CourseDecorator.decorate_collection(
      Course.all_published.order(:title).page params[:page]
    )
  end

  def show
    @course = Course.find(params[:id]).decorate
    authorize! :publicated, @course.object
    @passage = @course.passages.new
  end
end
