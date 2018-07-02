class CreateRoleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :role_users do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false

      t.timestamps
    end

    add_index :role_users, [:user_id, :role_id], unique: true
  end
end
