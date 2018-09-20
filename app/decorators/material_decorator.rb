class MaterialDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasHtmlAttributes
  include HasTextPreview

  delegate_all

  html_attributes :body, :summary
  text_preview :title
end
