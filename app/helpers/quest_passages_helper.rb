module QuestPassagesHelper
  def quest_passage_color_status(quest_passage)
    quest_passage.passed? ? 'bg-green' : 'bg_grey'
  end
end
