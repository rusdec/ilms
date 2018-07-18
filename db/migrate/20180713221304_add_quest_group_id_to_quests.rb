class AddQuestGroupIdToQuests < ActiveRecord::Migration[5.2]
  def change
    add_reference :quests, :quest_group, foreign_key: true
  end
end
