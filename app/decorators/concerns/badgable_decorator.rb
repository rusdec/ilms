module BadgableDecorator
  def link_to_badge
    if badge
      h.render partial: 'shared/badges/mini_card',
               locals: { badge: badge }
    else
      h.link_to 'Create Badge',
                h.polymorphic_path([:new, :course_master, object, :badge])
    end
  end
end
