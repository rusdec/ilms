class CreateLessonHierarchies < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :lesson_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "lessons_anc_desc_idx"

    add_index :lesson_hierarchies, [:descendant_id],
      name: "lessons_desc_idx"
  end
end
