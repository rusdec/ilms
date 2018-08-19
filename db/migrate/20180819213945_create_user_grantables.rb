class CreateUserGrantables < ActiveRecord::Migration[5.2]
  def change
    create_table :user_grantables do |t|
      t.references :user, foreign_key: true
      t.references :grantable, polymorphic: true

      t.timestamps
    end
  end
end
