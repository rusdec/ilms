class CourseDecorator < Draper::Decorator
  include PassableDecorator
  include HasDate
  include BadgableDecorator
  include HasHtmlAttributes

  delegate_all
  decorates_association :author
  decorates_association :badge
  decorates_association :badges
  decorates_association :passaged_badges
  decorates_association :lessons

  html_attributes :decoration_description

  def title_preview
    object.title.truncate(30)
  end

  def button_new_lesson
    h.link_to 'New Lesson',
              h.new_course_master_course_lesson_path(object),
              class: 'btn btn-primary'
  end

  def button_new_passaged_badge
    h.link_to 'New Passaged Badge',
              h.new_course_master_course_passaged_badge_path(object),
              class: 'btn btn-primary'
  end
end
