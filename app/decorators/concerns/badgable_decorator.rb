module BadgableDecorator
  def link_to_badge
    if object.badge
      h.link_to object.badge.title, h.edit_course_master_badge_path(object.badge)
    else
      h.link_to 'Create Badge',
                h.polymorphic_path([:new, :course_master, object, :badge])
    end
  end
end
