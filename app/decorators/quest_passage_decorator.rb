class QuestPassageDecorator < PassageDecorator
  include HasDate
  include HasHtmlAttributes

  delegate_all

  html_attributes :body
end
