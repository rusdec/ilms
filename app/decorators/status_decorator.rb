class StatusDecorator < Draper::Decorator
  delegate_all

  STATUSES = {
    passed:       { title: 'accepted',    css: { badge: 'badge-success' } },
    declined:     { title: 'declined',    css: { badge: 'badge-danger'  } },
    unverified:   { title: 'unverified',  css: { badge: 'badge-default' } },
    unavailable:  { title: 'unavailable', css: { badge: 'badge-danger'  } },
    in_progress:  { title: 'in_progress', css: { badge: 'badge-default' } },
  }.freeze

  def badge
    h.tag.span current_status[:title], class: "badge #{current_status[:css][:badge]}"
  end

  protected

  def current_status
    STATUSES[name.to_sym]
  end
end
