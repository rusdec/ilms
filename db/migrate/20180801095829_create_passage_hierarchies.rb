class CreatePassageHierarchies < ActiveRecord::Migration[5.2]
  def change
    create_table :passage_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :passage_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "passage_anc_desc_idx"

    add_index :passage_hierarchies, [:descendant_id],
      name: "passage_desc_idx"
  end
end
