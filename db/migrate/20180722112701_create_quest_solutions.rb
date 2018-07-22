class CreateQuestSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :quest_solutions do |t|
      t.references :quest_passage, foreign_key: true
      t.text :body
      t.boolean :passed, default: false

      t.timestamps
    end
  end
end
