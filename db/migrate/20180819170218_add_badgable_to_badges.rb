class AddBadgableToBadges < ActiveRecord::Migration[5.2]
  def change
    add_reference :badges, :badgable, polymorphic: true
  end
end
