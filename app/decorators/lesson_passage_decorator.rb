class LessonPassageDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def quest_passages_by_quest_group
    passable.quest_groups.collect do |quest_group|
      children.where(passable: quest_group.quests)
    end
  end
end
