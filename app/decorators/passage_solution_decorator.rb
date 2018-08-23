class PassageSolutionDecorator < Draper::Decorator
  include HasDate
  include HasHtmlAttributes

  delegate_all

  decorates_association :status
  decorates_association :passage

  html_attributes :body
end
