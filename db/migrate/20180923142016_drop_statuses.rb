class DropStatuses < ActiveRecord::Migration[5.2]
  def up
    drop_table :statuses
  end

  def down
    create_table :statuses do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :statuses, :name, unique: true
  end
end
