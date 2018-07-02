class AddTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :type, :string, default: 'User', null: false
  end
end
