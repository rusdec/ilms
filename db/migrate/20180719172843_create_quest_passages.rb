class CreateQuestPassages < ActiveRecord::Migration[5.2]
  def change
    create_table :quest_passages do |t|
      t.references :quest_group, foreign_key: true
      t.references :educable, polymorphic: true
      t.references :lesson_passage, foreign_key: true
      t.boolean :passed, default: false

      t.timestamps
    end
  end
end
