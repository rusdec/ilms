class QuestPassagesController < ApplicationController
  before_action :authenticate_user!, only: :show

  def show
    @quest_passage = QuestPassage.find(params[:quest_passage_id])
    authorize! :owner_education, @quest_passage.lesson_passage.course_passage
    @quest = Quest.find(params[:quest_id])
  end
end
