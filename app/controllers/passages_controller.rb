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
    puts @passage.inspect
    puts current_user.inspect
    puts @passage.user == current_user

    #authorize! :passing, @passage
    render "#{passable_type}/passages/show"
  end

  protected

  def set_passage
    @passage = Passage.find(params[:id])
    @passage = decorator_class.decorate(@passage)
  end

  def decorator_class
    "#{passable_class}PassageDecorator".constantize
  end

  def passable_type
    passable_class.to_s.pluralize.underscore
  end

  def passable_class
    @passage.passable.class
  end

  def set_passages
    @passages = Passage.where(
      user: current_user, passable_type: params[:passable_type].classify
    )
  end
end
