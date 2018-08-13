class LessonPassage < Passage
  # Statusable Template method
  def ready_to_pass?
    groups = passable.quest_groups.pluck(:id).sort
    passed_groups = children.all_passed
                      .joins('JOIN quests ON passages.passable_id = quests.id')
                      .pluck(:quest_group_id).uniq.sort

    groups == passed_groups
  end

  # Passage Template method
  def after_pass_hook
    #passable.children.each(&:in_progress!)
  end
end
