class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.references :lesson, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title
      t.text :body
      t.text :summary
      t.integer :order

      t.timestamps
    end
  end
end
