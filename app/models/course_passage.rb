class CoursePassage < Passage
  # Passage Template method
  def ready_to_pass?
    children.all_passed.count == children.count
  end
end
