class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.references :user, foreign_key: true
      t.text :decoration_description, default: ''
      t.integer :level, default: 1

      t.timestamps
    end
  end
end
