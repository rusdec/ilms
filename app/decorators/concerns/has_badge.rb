module HasBadge
  def link_to_edit_badge
    if badge
      h.render partial: 'shared/badges/edit_mini_card',
               locals: { badge: badge }
    else
      h.link_to I18n.t('decorators.has_badge.new_badge'),
        h.polymorphic_path([:new, :course_master, object, :badge], locale: I18n.locale),
                class: 'btn btn-secondary'
    end
  end
end
