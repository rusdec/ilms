class QuestSolutionsController < ApplicationController
  include JsonResponsed

  before_action :authenticate_user!
  before_action :set_course_passage
  before_action :set_quest_passage

  def create
    authorize! :owner_education, @course_passage
    @quest_solution = @quest_passage.quest_solutions.create(quest_solution_params)
    json_response_by_result
  end

  private

  def set_course_passage
    @course_passage = CoursePassage.find(params[:course_passage_id])
  end

  def set_quest_passage
    @quest_passage = QuestPassage.find(params[:quest_passage_id])
  end

  def quest_solution_params
    params.require(:quest_solution).permit(:body)
  end
end
