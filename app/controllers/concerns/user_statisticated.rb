module UserStatisticated
  extend ActiveSupport::Concern

  included do
    before_action :set_statistic_attributes, only: %i(
      courses_progress
      lessons_progress
      quests_progress
      badges_progress
      top_three_knowledges
      knowledges_directions
    )

    def courses_progress
      respond_to do |format|
        format.json { render json: @statistic.courses_progress }
      end
    end

    def lessons_progress
      respond_to do |format|
        format.json { render json: @statistic.lessons_progress }
      end
    end

    def quests_progress
      respond_to do |format|
        format.json { render json: @statistic.quests_progress }
      end
    end

    def badges_progress
      respond_to do |format|
        format.json { render json: @statistic.badges_progress }
      end
    end

    def top_three_knowledges
      respond_to do |format|
        format.json { render json: @statistic.top_three_knowledges }
      end
    end

    def knowledges_directions
      respond_to do |format|
        format.json { render json: @statistic.knowledges_directions }
      end
    end

    protected

    def set_statistic_attributes
      set_statistic_user
      set_statistic
    end

    def set_statistic
      @statistic = UserStatistic.new(@statistic_user)
    end

    def set_statistic_user
      @statistic_user = User.find(params[:user_id])
    end
  end
end
