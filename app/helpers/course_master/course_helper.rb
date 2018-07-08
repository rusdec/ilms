module CourseMaster::CourseHelper
  def course_info(course)
    content_tag :span, class: 'small text-secondary' do
      [
        "Level: #{course.level}",
        "Author: #{course.author.full_name}",
        "Created: #{format_date(course.created_at)}"
      ].each { |text| concat("#{text}#{tag.br}".html_safe) }
    end
  end

  def course_remote_links(course)
    yield_if_author(course) do
      content_tag :span, class: 'remote-links small' do
        concat(link_to 'Edit', edit_course_master_course_path(course))
        concat(link_to 'Delete', course_master_course_path(course),
                                 class: "link-#{underscored_klass(course)}-delete",
                                 method: :delete,
                                 remote: true)
      end
    end
  end

  def add_lesson_link(course)
    yield_if_author(course) do
      link_to 'Add lesson', new_course_master_course_lesson_path(course)
    end
  end
end
