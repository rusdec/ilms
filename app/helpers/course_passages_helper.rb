module CoursePassagesHelper
  def lesson_passages_list(course_passage)
    "#{available_lesson_passages(course_passage).join}
    #{unavailable_lesson_passages(course_passage).join}".html_safe
  end

  def unavailable_lesson_passages(course_passage)
    ids = course_passage.lesson_passages.pluck(:lesson_id)

    course_passage.course.lessons.where.not(id: ids).collect do |lesson|
      content_tag :span, class: 'list-group-item list-group-item-action text-secondary' do
        concat(icon('fas', 'lock', class: 'mr-1'))
        concat(lesson.title)
      end
    end
  end

  def available_lesson_passages(course_passage)
    course_passage.lesson_passages.collect do |lesson_passage|
      link_to lesson_passage.lesson.title,
        course_passage_lesson_path(lesson_passage.course_passage, lesson_passage),
        class: 'list-group-item list-group-item-action'
    end
  end
end
