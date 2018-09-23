class PassageSolutionDecorator < Draper::Decorator
  include HasDate
  include HasHtmlAttributes
  include HasStatus

  delegate_all

  decorates_association :passage

  html_attributes :body
end
