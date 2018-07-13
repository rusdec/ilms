class AddLessonIdToQuests < ActiveRecord::Migration[5.2]
  def change
    change_table :quests do |t|
      t.references :lesson, foreign_key: true
    end
  end
end
