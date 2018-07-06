class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.references :course, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.text :ideas, default: ''
      t.text :summary, default: ''
      t.text :check_yourself, default: ''
      t.integer :order, default: 1
      t.timestamps
    end
  end
end
