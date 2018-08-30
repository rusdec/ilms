class CoursePassage < Passage
  has_many :quest_passages, through: :children, source: :children
  alias_attribute :lesson_passages, :children
  alias_attribute :course, :passable

  # Passage Template method
  def ready_to_pass?
    children.all_passed.count == children.count
  end

  # Passage Template method
  def after_pass_hook
    user.reward!(passable.badge) if passable.badge
  end

  def passed_quest_passages
    quest_passages.all_passed
  end

  def passed_lesson_passages
    children.all_passed
  end
end
