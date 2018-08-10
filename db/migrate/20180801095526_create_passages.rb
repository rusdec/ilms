class CreatePassages < ActiveRecord::Migration[5.2]
  def change
    create_table :passages do |t|
      t.references :passable, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :parent_id
      t.references :status

      t.timestamps
    end
  end
end
