class AddDifficultyToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :courses,  :difficulty, :integer, default: 1, null: false
    add_column :lessons,  :difficulty, :integer, default: 1, null: false
    add_column :quests,   :difficulty, :integer, default: 1, null: false

    remove_column :courses, :level, :integer, default: 1
    remove_column :quests,  :level, :integer, default: 1
  end
end
