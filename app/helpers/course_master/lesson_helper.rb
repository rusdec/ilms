module CourseMaster::LessonHelper
  def text_or_none(text = '')
    text.empty? ? 'none' : text
  end

  def lesson_remote_links(lesson)
    yield_if_author(lesson) do
      content_tag :span, class: 'remote-links small' do
        concat(link_to 'Edit', edit_course_master_lesson_path(lesson))
        concat(link_to 'Delete', course_master_lesson_path(lesson),
                                 class: "destroy_#{underscored_klass(lesson)}",
                                 method: :delete,
                                 remote: true)
      end
    end
  end

  def add_quest_link(lesson)
    yield_if_author(lesson) do
      link_to 'Add quest', new_course_master_lesson_quest_path(lesson)
    end
  end

  def add_material_link(lesson)
    yield_if_author(lesson) { link_to 'Add material', path: '' }
  end

  def selector_with_lessons(params)
    lessons = params[:lesson].course.lessons.persisted.collect do |lesson|
      [lesson.title, lesson.id]
    end

    params[:form].select :parent_id, lessons, { include_blank: true },
                                              class: 'form-control'
  end
end
