class CreateQuests < ActiveRecord::Migration[5.2]
  def change
    create_table :quests do |t|
      t.references :lesson, foreign_key: true
      t.string :title
      t.text :description
      t.integer :level

      t.timestamps
    end
  end
end
