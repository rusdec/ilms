class StatusDecorator < Draper::Decorator
  delegate_all

  STATUSES = {
    passed:       { css: { badge: 'badge-success' } },
    accepted:     { css: { badge: 'badge-success' } },
    declined:     { css: { badge: 'badge-danger'  } },
    unverified:   { css: { badge: 'badge-default' } },
    unavailable:  { css: { badge: 'badge-danger'  } },
    in_progress:  { css: { badge: 'badge-default' } },
  }.freeze

  def badge
    h.tag.span I18n.t("statuses.#{name}"), class: "badge #{current_status[:css][:badge]}"
  end

  protected

  def current_status
    STATUSES[name.to_sym]
  end
end
