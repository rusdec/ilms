class AddOldQuestGroupToQuests < ActiveRecord::Migration[5.2]
  def change
    add_column :quests, :old_quest_group_id, :integer
    add_index :quests, :old_quest_group_id
  end
end
