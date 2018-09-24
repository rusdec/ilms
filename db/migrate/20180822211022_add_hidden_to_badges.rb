class AddHiddenToBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :badges, :hidden, :boolean, default: false
  end
end
