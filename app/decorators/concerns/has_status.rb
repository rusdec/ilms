module HasStatus
  extend ActiveSupport::Concern

  included do
    STATUSES = {
      passed:       { css: { badge: 'badge-success' } },
      accepted:     { css: { badge: 'badge-success' } },
      declined:     { css: { badge: 'badge-danger'  } },
      unverified:   { css: { badge: 'badge-default' } },
      unavailable:  { css: { badge: 'badge-danger'  } },
      in_progress:  { css: { badge: 'badge-default' } },
    }.freeze

    def status_badge
      h.tag.span I18n.t("statuses.#{current_status}"),
                 class: "badge #{STATUSES[current_status][:css][:badge]}"
    end

    def current_status
      status.to_sym
    end
  end
end
