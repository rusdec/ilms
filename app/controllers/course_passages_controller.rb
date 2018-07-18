class CoursePassagesController < ApplicationController
  include JsonResponsed

  before_action :authenticate_user!

  protect_from_forgery except: :create

  respond_to :json, only: :create
  respond_to :html, only: %i(show index)
  before_action :verify_requested_format!

  before_action :set_course, only: :create
  before_action :set_course_passage, only: :show

  def index
    @course_passages = current_user.course_passages
  end

  def create
    @course_passage = current_user.course_passages.create(course: @course)
    json_response_by_result(with_location: :course_passage_url,
                            without_object: true, with_flash: true)
  end

  def show
    authorize! :owner_education, @course_passage
    @lesson_passages = @course_passage.lesson_passages
  end

  private

  def set_course
    @course = Course.find_by(id: course_passage_params[:course_id])
  end

  def set_course_passage
    @course_passage = CoursePassage.find(params[:id])
  end

  def course_passage_params
    params.require(:course_passage).permit(:course_id)
  end
end
