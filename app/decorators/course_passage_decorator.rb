class CoursePassageDecorator < Draper::Decorator
  delegate_all

  def lesson_passages
    children.collect do |lesson_passage|
      h.link_to lesson_passage.passable.title, h.passage_path(lesson_passage),
                class: 'list-group-item list-group-item-action'
    end.join.html_safe
  end
end
