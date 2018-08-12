class AddPassageTypeToPassages < ActiveRecord::Migration[5.2]
  def change
    add_column :passages, :type, :string
  end
end
