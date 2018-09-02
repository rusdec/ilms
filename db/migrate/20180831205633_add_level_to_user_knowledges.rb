class AddLevelToUserKnowledges < ActiveRecord::Migration[5.2]
  def change
    add_column :user_knowledges, :level, :integer, default: 0, null: false
  end
end
