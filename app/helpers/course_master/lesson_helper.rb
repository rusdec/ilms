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
    yield_if_author(lesson) { link_to 'Add quest', path: '' }
  end

  def add_material_link(lesson)
    yield_if_author(lesson) { link_to 'Add material', path: '' }
  end
end