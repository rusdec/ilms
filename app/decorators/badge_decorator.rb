class BadgeDecorator < Draper::Decorator
  include HasDate
  include HasImage
  include HasRemoteLinks
  include HasHtmlAttributes

  delegate_all

  html_attributes :description

  def title_preview
    object.title.truncate(30)
  end

  def description_preview
    description_as_text.truncate(30)
  end

  def link_to_related_badgable(params = {})
    h.link_to "Related #{badgable.class}",
      h.polymorphic_path([:edit, :course_master, badgable], locale: I18n.locale),
              params
  end

  def edit_path
    h.edit_course_master_badge_path(self)
  end

  def mini_card
    h.render partial: 'shared/badges/mini_card', locals: { badge: self }
  end

  def disabled_mini_card
    h.render partial: 'shared/badges/disabled_mini_card', locals: { badge: self }
  end
end
