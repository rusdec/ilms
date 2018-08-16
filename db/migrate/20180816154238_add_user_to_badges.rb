class AddUserToBadges < ActiveRecord::Migration[5.2]
  def change
    add_reference :badges, :user, foreign_key: true
  end
end
