module CourseMaster::LessonHelper
  def text_or_none(text = '')
    text.empty? ? 'none' : text
  end

  def lesson_remote_links(lesson)
    remote_links([lesson])
  end

  def add_quest_link(lesson)
    yield_if_author(lesson) do
      link_to 'Add quest', new_course_master_lesson_quest_path(lesson)
    end
  end

  def add_material_link(lesson)
    yield_if_author(lesson) do
      link_to 'Add material', new_course_master_lesson_material_path(lesson)
    end
  end

  def selector_with_lessons(params)
    lessons = params[:lesson].course.lessons.persisted.collect do |lesson|
      [lesson.title, lesson.id]
    end

    params[:form].select :parent_id, lessons, { include_blank: true },
                                              class: 'form-control'
  end
end
