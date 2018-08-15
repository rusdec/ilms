module CourseMaster::CourseHelper
  def course_info(course)
    content_tag :span, class: 'small text-secondary' do
      [
        "Level: #{course.level}",
        "Author: #{course.author.full_name}",
        "Created: #{course.created_at}"
      ].each { |text| concat("#{text}#{tag.br}".html_safe) }
    end
  end

  def course_remote_links(course)
    remote_links([course])
  end

  def add_lesson_link(course)
    yield_if_author(course) do
      link_to 'Add lesson', new_course_master_course_lesson_path(course)
    end
  end
end
