class AddCourseToBadges < ActiveRecord::Migration[5.2]
  def change
    add_reference :badges, :course, foreign_key: true, index: true
  end
end
