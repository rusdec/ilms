class LessonPassagesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_lesson_passage, only: :show

  respond_to :html, only: :show

  def show
    @lesson = @lesson_passage.lesson
    authorize! :owner_education, @lesson_passage.course_passage
  end

  private

  def set_lesson_passage
    @lesson_passage = LessonPassage.find(params[:id])
  end
end
