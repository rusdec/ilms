class CoursePassageDecorator < PassageDecorator
  include HasCards
  include HasDate

  delegate_all

  decorates_association :lesson_passages

  def lessons_progress_card
    progress_card(
      title: 'Lessons',
      body: "#{passed_lesson_passages.count} from #{children.count}",
      percent: passed_lesson_passages_percent
    )
  end

  def quests_progress_card
    progress_card(
      title: 'Quests',
      body: "#{passed_quest_passages.count} from #{quest_passages.count}",
      percent: passed_quest_passages_percent
    )
  end

  def passed_lesson_passages_percent
    return 0 if children.count == 0
    ((passed_lesson_passages.count.to_f/children.count.to_f) * 100).to_i
  end

  def passed_quest_passages_percent
    return 0 if children.count == 0
    ((passed_quest_passages.count.to_f/quest_passages.count.to_f) * 100).to_i
  end

  def lessons_progress_bar
    percent = passed_lesson_passages_percent
    color = h.progress_color(percent)

    h.render partial: 'shared/progress_bar',
             locals: { percent: percent, progress_color: color }
  end
end
