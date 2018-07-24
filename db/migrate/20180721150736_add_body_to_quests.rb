class AddBodyToQuests < ActiveRecord::Migration[5.2]
  def change
    add_column :quests, :body, :text
  end
end
