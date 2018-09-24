class AddSortOrderToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :sort_order, :integer
    add_index :lessons, :sort_order
  end
end
