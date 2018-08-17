class QuestPassage < Passage
  # Passage Template method
  def ready_to_pass?
    solutions.all_accepted.any?
  end

  # Passage Temaplate method
  def can_be_in_progress?
    true
  end
end
