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

  def edit_link(course)
    if can? :author_of_course, course
      link_to 'Edit', edit_course_master_course_path(course)
    end
  end
end
