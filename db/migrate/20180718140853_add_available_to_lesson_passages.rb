class AddAvailableToLessonPassages < ActiveRecord::Migration[5.2]
  def change
    add_column :lesson_passages, :available, :boolean, default: false
  end
end
