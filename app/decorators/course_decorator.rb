class CourseDecorator < Draper::Decorator
  include PassableDecorator
  include HasDate
  include BadgableDecorator
  include HasHtmlAttributes
  include HasTextPreview
  include HasRemoteLinks

  delegate_all
  decorates_association :author
  decorates_association :badge
  decorates_association :badges
  decorates_association :lessons

  html_attributes :decoration_description
  text_preview :title

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

  def published_status_icon
    h.tag.span class: "status-icon #{published? ? 'bg-success' : 'bg-secondary'}"
  end
end
