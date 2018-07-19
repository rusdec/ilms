module CoursePassagesHelper
  def link_to_lesson_passage(lesson_passage)
    if lesson_passage.is_available?
      link_to lesson_passage.lesson.title,
        course_passage_lesson_path(lesson_passage.course_passage, lesson_passage),
        class: 'list-group-item list-group-item-action'
    else
      content_tag :span, class: 'list-group-item list-group-item-action text-secondary' do
        concat(icon('fas', 'lock', class: 'mr-1'))
        concat(lesson_passage.lesson.title)
      end
    end
  end
end
