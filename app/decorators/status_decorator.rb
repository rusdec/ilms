class StatusDecorator < Draper::Decorator
  delegate_all

  STATUSES = {
    passed:     { title: 'accepted',    css: { badge: 'badge-success' } },
    not_passed: { title: 'declined',     css: { badge: 'badge-danger'  } },
    unverified: { title: 'unverified',  css: { badge: 'badge-default' } }
  }.freeze

  def status
    current_status[:title]
  end

  def badge
    h.tag.span status, class: "badge #{current_status[:css][:badge]}"
  end

  protected

  def current_status
    STATUSES[id]
  end
end
