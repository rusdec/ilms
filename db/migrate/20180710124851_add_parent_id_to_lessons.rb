class AddParentIdToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :parent_id, :integer
  end
end
