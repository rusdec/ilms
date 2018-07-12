class AddLessonIdToQuests < ActiveRecord::Migration[5.2]
  def change
    add_column :quests, :lesson_id, :integer, null: true
    add_index :quests, :lesson_id
  end
end
