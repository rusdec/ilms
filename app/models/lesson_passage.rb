class LessonPassage < Passage
  after_create :after_create_hook_open_passage_if_root

  # Statusable Template method
  def ready_to_pass?
    groups = passable.quest_groups.pluck(:id).sort
    passed_groups = children.all_passed
                      .joins('JOIN quests ON passages.passable_id = quests.id')
                      .pluck(:quest_group_id).uniq.sort

    groups == passed_groups
  end

  # Statusable Template method
  def default_status
    :unavailable
  end

  def open!
    transaction do
      in_progress!
      children.each(&:open!)
    end
  end

  protected

  # Passage Template method
  def after_pass_hook
    # open next lessons and their quests
    siblings.where(passable_id: passable.children.pluck(:id)).each(&:open!)
  end

  def after_create_hook_open_passage_if_root
    open! if passable.root?
  end
end
