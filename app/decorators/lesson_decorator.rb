class LessonDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasTextPreview
  include HasHtmlAttributes
  include HasDifficulty

  delegate_all

  decorates_association :author
  decorates_association :course
  decorates_association :quests
  decorates_association :materials

  html_attributes :ideas, :summary, :check_yourself
  text_preview :title

  def button_new_material
    h.link_to I18n.t('decorators.lesson.new_material'),
      h.new_course_master_lesson_material_path(object, locale: I18n.locale),
              class: 'btn btn-primary'
  end

  def button_new_quest
    h.link_to I18n.t('decorators.lesson.new_quest'),
      h.new_course_master_lesson_quest_path(object, locale: I18n.locale),
              class: 'btn btn-primary'
  end
end
