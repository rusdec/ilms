class UserStatistic
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def knowledges_directions
    user.user_knowledges.by_directions.collect do |direction, user_knowledges|
      { direction: direction,
        sum_of_levels: user_knowledges.sum { |uk| uk.level },
        user_knowledges: user_knowledges.collect { |uk| { level: uk.level,
                                                          knowledge: uk.knowledge } } }
    end 
  end

  def badges_progress
    { badges: {
        collected: user.badges.count,
        total: user.all_badges_for_passaged_courses.count
      }
    }
  end

  def courses_progress
    { courses: {
        passed: user.passed_courses.uniq.count,
        in_progress: user.in_progress_courses.count
      }
    }
  end

  def lessons_progress
    { lessons: {
        passed: user.passed_lessons.uniq.count,
        unavailable: user.unavailable_lessons.count,
        in_progress: user.in_progress_lessons.count
      }
    }
  end

  def quests_progress
    { quests: {
        passed: user.passed_quests.uniq.count,
        in_progress: user.in_progress_quests.count
      }
    }
  end

  def top_three_knowledges
    knowledges = user.user_knowledges.order(level: :desc).limit(3)
    { knowledges: knowledges.collect do |user_knowledge|
                    { level: user_knowledge.level,
                      knowledge: user_knowledge.knowledge }
                  end }
  end
end
