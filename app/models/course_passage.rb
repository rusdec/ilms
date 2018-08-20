class CoursePassage < Passage
  # Passage Template method
  def ready_to_pass?
    children.all_passed.count == children.count
  end

  # Passage Template method
  def after_pass_hook
    self.user.reward!(passable.badge) if passable.badge
  end
end
