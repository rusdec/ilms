module CourseMaster::LessonHelper
  def text_or_none(text = '')
    text.empty? ? 'none' : text
  end

  def selector_with_lessons(params)
    lessons = params[:lessons].collect do |lesson|
      [lesson.title, lesson.id]
    end

    params[:form].select :parent_id, lessons, { include_blank: true },
                                              class: 'form-control'
  end

  def lessons_path(lesson)
    "#{edit_course_master_course_path(lesson.course)}#lessons"
  end
end
