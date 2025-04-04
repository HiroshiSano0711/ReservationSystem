class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :permalink, null: false
      t.text :description
      t.string :phone_number

      t.timestamps
    end
  end
end
