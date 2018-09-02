class QuestPassage < Passage
  include ExperienceDistributable

  belongs_to :quest, foreign_key: :passable_id

  # Passage Template method
  def ready_to_pass?
    solutions.all_accepted.any?
  end

  # Passage Temaplate method
  def can_be_in_progress?
    true
  end

  # Passage Template method
  def after_pass_hook
    self.user.reward!(passable.badge) if passable.badge
    destribute_experience_between_knowledges
  end
end
