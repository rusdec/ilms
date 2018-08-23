class MaterialDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasHtmlAttributes

  delegate_all

  html_attributes :body, :summary
end
