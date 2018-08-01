class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses, id: false do |t|
      t.string :id, primary_key: true
      t.timestamps
    end

    add_index :statuses, :id, unique: true
  end
end
