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

  def description(text = '')
    text.empty? ? 'none' : text
  end

  def remote_links(course)
    if can? :author_of_course, course
      content_tag :span, class: 'remote-links small' do
        concat(link_to 'Edit', edit_course_master_course_path(course))
        concat(link_to 'Delete', course_master_course_path(course),
                                 class: "link-#{underscored_klass(course)}-delete",
                                 method: :delete,
                                 remote: true)
      end
    end
  end
end
