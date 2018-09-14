class CourseDecorator < Draper::Decorator
  include HasPassage
  include HasDate
  include HasBadge
  include HasHtmlAttributes
  include HasTextPreview
  include HasRemoteLinks
  include HasDifficulty
  include HasImage

  delegate_all
  decorates_association :author
  decorates_association :badge
  decorates_association :badges
  decorates_association :lessons
  decorates_association :course_knowledges

  html_attributes :decoration_description
  text_preview :title

  def button_new_lesson
    h.link_to I18n.t('decorator.course.new_lesson'),
      h.new_course_master_course_lesson_path(object, locale: I18n.locale),
              class: 'btn btn-primary'
  end

  def button_new_passaged_badge
    h.link_to I18n.t('decorator.course.new_badge'),
              h.new_course_master_course_passaged_badge_path(object),
              class: 'btn btn-primary'
  end

  def published_status_icon
    h.tag.span class: "status-icon #{published? ? 'bg-success' : 'bg-secondary'}"
  end
end
