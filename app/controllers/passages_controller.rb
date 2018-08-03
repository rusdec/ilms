class PassagesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_passage, only: :show
  before_action :set_passages, only: :index

  respond_to :html, only: %i(show index)
  before_action :verify_requested_format!

  def index
    render "#{params[:passable_type]}/passages/index"
  end

  def show
    authorize! :passing, @passage
    render "#{passable_type}/passages/show"
  end

  protected

  def set_passage
    @passage = Passage.find(params[:id])
  end

  def passable_type
    @passage.passable.class.to_s.pluralize.underscore
  end

  def set_passages
    @passages = Passage.where(
      user: current_user, passable_type: params[:passable_type].classify
    )
  end
end
