class CreateCoursePassages < ActiveRecord::Migration[5.2]
  def change
    create_table :course_passages do |t|
      t.references :course, foreign_key: true
      t.references :educable, polymorphic: true
      t.boolean :passed, default: false

      t.timestamps
    end
  end
end
