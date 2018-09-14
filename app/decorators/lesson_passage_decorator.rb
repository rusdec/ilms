class LessonPassageDecorator < PassageDecorator
  def quest_passages_by_quest_group
    passable.quest_groups.collect do |quest_group|
      children.where(passable: quest_group.quests)
    end
  end

  def td_required_quests
    required_quests = passable.quest_groups.count
    required_quests > 0 ? required_quests : I18n.t('decorators.lesson_passages.read_only')
  end
end
