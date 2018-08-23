class LessonDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasTextPreview

  delegate_all

  decorates_association :author
  decorates_association :course
  decorates_association :quests
  decorates_association :materials

  text_preview :title
end
