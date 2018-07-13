class CreateAlternativeQuests < ActiveRecord::Migration[5.2]
  def change
    create_table :alternative_quests do |t|
      t.references :quest, foreign_key: true
      t.integer :alternative_quest_id

      t.timestamps
    end

    add_index :alternative_quests, [:quest_id, :alternative_quest_id], unique: true
  end
end
