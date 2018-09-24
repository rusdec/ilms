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

    breadcrumb 'courses', courses_path, match: :exact
    breadcrumb @course.title, course_path(@course), match: :exact
    @passage = @course.passages.new
  end
end
