class CreateQuestGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :quest_groups do |t|
      t.belongs_to :lesson, foreign_key: true
      t.timestamps
    end
  end
end
