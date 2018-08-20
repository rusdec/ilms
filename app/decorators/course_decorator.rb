class CourseDecorator < Draper::Decorator
  include PassableDecorator
  include DateDecorator
  include BadgableDecorator

  delegate_all
  decorates_association :author

  def title_preview
    object.title.truncate(30)
  end
end
