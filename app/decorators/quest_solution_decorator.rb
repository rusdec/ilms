class QuestSolutionDecorator < Draper::Decorator
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
    status = current_status
    h.tag.span status[:title], class: "badge #{status[:css][:badge]}"
  end

  private

  def current_status
    if !verified?
      STATUSES[:unverified]
    elsif passed?
      STATUSES[:passed]
    else
      STATUSES[:not_passed]
    end
  end
end
