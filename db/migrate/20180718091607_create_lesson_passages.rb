class CreateLessonPassages < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_passages do |t|
      t.references :lesson, foreign_key: true
      t.references :educable, polymorphic: true
      t.boolean :passed, default: false
      t.references :course_passage, foreign_key: true

      t.timestamps
    end
  end
end
