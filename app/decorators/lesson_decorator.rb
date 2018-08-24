class LessonDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasTextPreview
  include HasHtmlAttributes

  delegate_all

  decorates_association :author
  decorates_association :course
  decorates_association :quests
  decorates_association :materials

  html_attributes :ideas, :summary, :check_yourself
  text_preview :title

  def button_new_material
    h.link_to 'New Material',
              h.new_course_master_lesson_material_path(object),
              class: 'btn btn-primary'
  end

  def button_new_quest
    h.link_to 'New Quest',
              h.new_course_master_lesson_quest_path(object),
              class: 'btn btn-primary'
  end
end
