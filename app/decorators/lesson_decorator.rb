class LessonDecorator < Draper::Decorator
  delegate_all

  decorates_association :author
  decorates_association :course

  def title_preview
    object.title.truncate(30)
  end
end
