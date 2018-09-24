class CreateUserKnowledges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_knowledges do |t|
      t.references :user, polymorphic: true
      t.references :knowledge, foreign_key: true

      t.timestamps
    end

    add_index :user_knowledges, [:user_id, :knowledge_id], unique: true
  end
end
