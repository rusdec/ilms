class RemoveOrderFromLessons < ActiveRecord::Migration[5.2]
  def change
    remove_column :lessons, :order, :integer
  end
end
