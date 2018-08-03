class CourseDecorator < Draper::Decorator
  delegate_all

  include PassableDecorator
end
