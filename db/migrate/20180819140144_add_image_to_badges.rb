class AddImageToBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :badges, :image, :string
  end
end
