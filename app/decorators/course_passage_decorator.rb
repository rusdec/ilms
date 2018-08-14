class CoursePassageDecorator < PassageDecorator
  def lesson_passages
    children.collect do |lesson_passage|
      title = "#{lesson_passage.passable.title} #{lesson_passage.status.badge}".html_safe

      if lesson_passage.unavailable?
        h.tag.span title, class: 'list-group-item list-group-item-action'
      else
        h.link_to title, h.passage_path(lesson_passage),
                         class: 'list-group-item list-group-item-action'
      end
    end.join.html_safe
  end
end
