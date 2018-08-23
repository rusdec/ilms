class QuestDecorator < Draper::Decorator
  include BadgableDecorator
  include HasDate
  include HasRemoteLinks
  include HasTextPreview
  include HasHtmlAttributes

  delegate_all

  decorates_association :author
  decorates_association :lesson
  decorates_association :badge

  html_attributes :body
  text_preview :title
end
