class ChangeStatusToEnumToPassages < ActiveRecord::Migration[5.2]
  def change
    remove_column :passages, :status_id, references: :status
    add_column :passages, :status, :integer
  end
end
