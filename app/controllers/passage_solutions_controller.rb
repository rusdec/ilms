class PassageSolutionsController < ApplicationController
  include JsonResponsed

  before_action :authenticate_user!
  before_action :set_passage

  def create
    authorize! :passing, @passage
    @passage_solution = @passage.solutions.create(passage_solution_params)
    json_response_by_result({ with_serializer: PassageSolutionSerializer })
  end

  private

  def set_passage
    @passage = Passage.find(params[:passage_id])
  end

  def passage_solution_params
    params.require(:passage_solution).permit(:body)
  end
end
