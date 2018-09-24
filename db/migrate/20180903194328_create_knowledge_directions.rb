class CreateKnowledgeDirections < ActiveRecord::Migration[5.2]
  def change
    create_table :knowledge_directions do |t|
      t.string :name, unique: true

      t.timestamps
    end
    
    add_index :knowledge_directions, :name, unique: true
  end
end
