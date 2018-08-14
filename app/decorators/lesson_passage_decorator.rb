class LessonPassageDecorator < PassageDecorator
  def quest_passages_by_quest_group
    passable.quest_groups.collect do |quest_group|
      children.where(passable: quest_group.quests)
    end
  end
end
