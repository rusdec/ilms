class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :title, null: false
      t.string :description, default: ''
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
