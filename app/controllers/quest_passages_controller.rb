class QuestPassagesController < ApplicationController
  before_action :authenticate_user!, only: :show

  before_action :set_course_passage

  def show
    authorize! :owner_education, @course_passage
    @quest_passage = QuestPassage.find(params[:id])
    @quest = @quest_passage.quest
    @quest_solution = @quest_passage.quest_solutions.new
  end

  private

  def set_course_passage
    @course_passage = CoursePassage.find(params[:course_passage_id])
  end
end
