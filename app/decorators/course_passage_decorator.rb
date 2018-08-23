class CoursePassageDecorator < PassageDecorator
  include HasCards

  def lesson_passages
    children.collect do |lesson_passage|
      lesson_passage = lesson_passage.decorate
      title = "#{lesson_passage.passable.title} #{lesson_passage.status.badge}".html_safe

      if lesson_passage.unavailable?
        h.tag.span title, class: 'list-group-item list-group-item-action'
      else
        h.link_to title, h.passage_path(lesson_passage),
                         class: 'list-group-item list-group-item-action'
      end
    end.join.html_safe
  end

  def current_progress_card
    passed = children.all_passed.count
    total = children.count

    progress_card(
      title: 'Lessons',
      body: "#{passed} from #{total}",
      percent: "#{(passed.to_f/total.to_f) * 100}"
    )
  end

  def passed_lessons
    children.all_passed.count
  end

  def non_passed_lessons
    children
  end
end
