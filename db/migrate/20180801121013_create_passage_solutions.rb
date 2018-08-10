class CreatePassageSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :passage_solutions do |t|
      t.references :passage, foreign_key: true
      t.text :body
      t.references :status

      t.timestamps
    end
  end
end
