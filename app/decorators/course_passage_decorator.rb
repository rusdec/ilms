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
    ((passed_lesson_passages.count.to_f/children.count.to_f) * 100).to_i
  end

  def passed_quest_passages_percent
    ((passed_quest_passages.count.to_f/quest_passages.count.to_f) * 100).to_i
  end

  def lessons_progress_bar
    percent = passed_lesson_passages_percent

    color = case percent
            when 0..30 then 'bg-red'
            when 31..70 then 'bg-yellow'
            when 71..100 then 'bg-green'
            end

    h.render partial: 'shared/progress_bar',
             locals: { percent: percent, color: color }
  end
end
