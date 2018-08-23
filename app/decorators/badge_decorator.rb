class BadgeDecorator < Draper::Decorator
  include HasDate
  include HasRemoteLinks
  include HasHtmlAttributes

  delegate_all

  html_attributes :description

  def title_preview
    object.title.truncate(30)
  end

  def image(params = {})
    return if object.image.file.nil?
    h.image_tag object.image.url, params
  end

  def image_preview(params = {})
    return if object.image.file.nil?
    h.image_tag object.image.preview.url, params
  end

  def description_preview
    description_as_text.truncate(30)
  end

  def link_to_related_badgable(params = {})
    h.link_to "Related #{badgable.class}",
              h.polymorphic_path([:edit, :course_master, badgable]),
              params
  end

  def edit_path
    h.edit_course_master_badge_path(self)
  end
end
