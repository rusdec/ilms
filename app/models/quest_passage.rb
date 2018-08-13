class QuestPassage < Passage
  # Passage Template method
  def ready_to_pass?
    solutions.all_accepted.any?
  end
end
