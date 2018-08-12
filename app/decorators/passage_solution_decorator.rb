class PassageSolutionDecorator < Draper::Decorator
  delegate_all

  STATUSES = {
    accepted:   { title: 'accepted',   css: { badge: 'badge-success' } },
    declined:   { title: 'declined',   css: { badge: 'badge-danger'  } },
    unverified: { title: 'unverified', css: { badge: 'badge-default' } }
  }.freeze

  def status
    current_status[:title]
  end

  def badge
    h.tag.span current_status[:title], class: "badge #{current_status[:css][:badge]}"
  end

  private

  def current_status
    STATUSES[object.status.name.to_sym]
  end
end
