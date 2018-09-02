class AddExperienceToUserKnowledges < ActiveRecord::Migration[5.2]
  def change
    add_column :user_knowledges, :experience, :integer, default: 0, null: false
  end
end
