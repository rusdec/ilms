class CourseDecorator < Draper::Decorator
  include PassableDecorator

  delegate_all
  decorates_association :author

  def title_preview
    object.title.truncate(30)
  end
end
