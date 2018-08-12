class QuestPassage < Passage
  # Passage Template method
  def ready_to_pass?
    solutions.all_accepted.any?
  end

  # Statusable Template method
  def after_update_status_hook
    parent.try_pass! if passed?
  end
end
