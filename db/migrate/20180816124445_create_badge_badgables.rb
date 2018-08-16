class CreateBadgeBadgables < ActiveRecord::Migration[5.2]
  def change
    create_table :badge_badgables do |t|
      t.references :badgable, polymorphic: true
      t.references :badge, foreign_key: true

      t.timestamps
    end
  end
end
