class CourseMaster::PassageSolutionsController < CourseMaster::BaseController
  include JsonResponsed

  before_action :set_passage_solutions, only: :index
  before_action :set_passage_solution, only: %i(accept decline show)
  before_action :require_author_abilities, only: %i(accept decline show)

  breadcrumb 'course_master.quests_solutions', :course_master_solutions_path,
                                               only: %i(index show), match: :exact

  respond_to :json, only: %i(accept decline)

  def index
    @passage_solutions = PassageSolutionDecorator.decorate_collection(@passage_solutions)
  end

  def show
    breadcrumb 'course_master.solution', course_master_solution_path(@passage_solution)
    @passage_solution = @passage_solution.decorate
  end

  def accept
    @passage_solution.accepted!
    json_response_by_result({ with_serializer: PassageSolutionSerializer })
  end

  def decline
    @passage_solution.declined!
    json_response_by_result({ with_serializer: PassageSolutionSerializer })
  end

  private

  def require_author_abilities
    authorize! :author, @passage_solution.passage.passable
  end

  def require_verify_abilities
    authorize! :verify, @passage_solution
  end

  def set_passage_solution
    @passage_solution = PassageSolution.find(params[:id])
  end

  def set_passage_solutions
    @passage_solutions = PassageSolution.for_auditor(current_user, :quests)
      .order(created_at: :desc)
      .page params[:page]
  end
end
