class CreateCourseKnowledges < ActiveRecord::Migration[5.2]
  def change
    create_table :course_knowledges do |t|
      t.references :course, foreign_key: true
      t.references :knowledge, foreign_key: true
      t.integer :percent

      t.timestamps
    end

    add_index :course_knowledges, [:course_id, :knowledge_id], unique: true
  end
end
