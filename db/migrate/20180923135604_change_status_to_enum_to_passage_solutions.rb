class ChangeStatusToEnumToPassageSolutions < ActiveRecord::Migration[5.2]
  def change
    remove_column :passage_solutions, :status_id, references: :status
    add_column :passage_solutions, :status, :integer
  end
end
