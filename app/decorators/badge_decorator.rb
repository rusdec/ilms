class BadgeDecorator < Draper::Decorator
  include DateDecorator
  include RemoteLinksDecorator
  include HtmlAttributesDecorator

  delegate_all

  html_attributes :description

  def title_preview
    object.title.truncate(30)
  end

  def description_preview
    description_as_text.truncate(30)
  end
end
