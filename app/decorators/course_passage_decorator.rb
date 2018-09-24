class CoursePassageDecorator < PassageDecorator
  include HasCards
  include HasDate

  delegate_all

  decorates_association :lesson_passages

  def lessons_progress_card
    progress_card(
      title: I18n.t('decorators.course_passage.lessons'),
      body: I18n.t('a_from_b', a: passed_lesson_passages.count, b: children.count),
      percent: passed_lesson_passages_percent
    )
  end

  def quests_progress_card
    progress_card(
      title: I18n.t('decorators.course_passage.quests'),
      body: I18n.t('a_from_b', a: passed_quest_passages.count, b: quest_passages.count),
      percent: passed_quest_passages_percent
    )
  end

  def passed_lesson_passages_percent
    return 0 if children.count == 0
    ((passed_lesson_passages.count.to_f/children.count.to_f) * 100).to_i
  end

  def passed_quest_passages_percent
    return 0 if children.empty? || quest_passages.empty?
    ((passed_quest_passages.count.to_f/quest_passages.count.to_f) * 100).to_i
  end

  def lessons_progress_bar
    percent = passed_lesson_passages_percent
    color = h.progress_color(percent)

    h.render partial: 'shared/progress_bar',
             locals: { percent: percent, progress_color: color }
  end
end
