class CourseMaster::KnowledgeDirectionsController < CourseMaster::BaseController
  include JsonResponsed

  def create
    @knowledge_direction = KnowledgeDirection.create(knowledge_direction_params)
    json_response_by_result
  end

  protected

  def knowledge_direction_params
    params.require(:knowledge_direction).permit(:name)
  end
end
