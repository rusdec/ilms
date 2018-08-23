class AddPublishedToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :published, :boolean, default: false
  end
end
