class CreateKnowledges < ActiveRecord::Migration[5.2]
  def change
    create_table :knowledges do |t|
      t.string :name

      t.timestamps
    end

    add_index :knowledges, :name, unique: true
  end
end
