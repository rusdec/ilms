class CourseMaster::QuestSolutionsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_quest_solutions, only: :index
  before_action :set_quest_solution, only: %i(accept decline show)
  before_action :require_author_abilities, only: %i(accept decline show)

  respond_to :json, only: %i(accept decline)

  def index; end

  def show; end

  def accept
    @quest_solution.accept!
    json_response_by_result
  end

  def decline
    @quest_solution.decline!
    json_response_by_result
  end

  private

  def require_author_abilities
    authorize! :author, @quest_solution.quest_passage.quest
  end

  def set_quest_solution
    @quest_solution = QuestSolutionDecorator.decorate(
      QuestSolution.find(params[:id])
    )
  end

  def set_quest_solutions
    @quest_solutions = QuestSolutionDecorator.decorate_collection(
      QuestSolution.for_auditor(current_user)
        .order(verified: :asc, updated_at: :desc)
    )
  end
end
