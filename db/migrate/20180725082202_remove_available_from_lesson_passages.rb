class RemoveAvailableFromLessonPassages < ActiveRecord::Migration[5.2]
  def change
    remove_column :lesson_passages, :available, :boolean, default: :false
  end
end
