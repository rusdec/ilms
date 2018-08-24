class PassagesController < ApplicationController
  include JsonResponsed

  before_action :authenticate_user!

  before_action :set_passage, only: %i(show try_pass)
  before_action :set_passable_type, only: :show
  before_action :set_passages, only: :index
  before_action :require_passing_abilities, only: %i(show try_pass)

  respond_to :html, only: %i(show index)
  respond_to :json, only: :try_pass
  before_action :verify_requested_format!

  def index
    render "#{params[:passable_type]}/passages/index"
  end

  def show
    @solution = @passage.solutions.new
    @passage = decorator_class.decorate(@passage)
    render "#{@passable_type}/passages/show"
  end

  def try_pass
    @passage.try_chain_pass!
    json_response_by_result({ with_serializer: PassageSerializer })
  end

  protected

  def require_passing_abilities
    authorize! :passing, @passage
  end

  def set_passage
    @passage = Passage.find(params[:id])
  end

  def decorator_class
    "#{passable_class}PassageDecorator".constantize
  end

  def set_passable_type
    @passable_type = passable_class.to_s.pluralize.underscore
  end

  def passable_class
    @passage.passable.class
  end

  def set_passages
    @passages = current_user.passages.where(passable_type: params[:passable_type].classify)
  end
end
