module BadgableDecorator
  def link_to_edit_badge
    if badge
      h.render partial: 'shared/badges/edit_mini_card',
               locals: { badge: badge }
    else
      h.link_to 'Create Badge',
                h.polymorphic_path([:new, :course_master, object, :badge]),
                class: 'btn btn-secondary'
    end
  end
end
