class LessonPassagesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_course_passage, only: :show
  before_action :set_lesson_passage, only: :show

  respond_to :html, only: :show

  def show
    authorize! :owner_education, @course_passage
    @lesson = @lesson_passage.lesson
    @quest_passages = @lesson_passage.quest_passages
  end

  private

  def set_lesson_passage
    @lesson_passage = LessonPassage.find(params[:id])
  end

  def set_course_passage
    @course_passage = CoursePassage.find(params[:course_passage_id])
  end
end
