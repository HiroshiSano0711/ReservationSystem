class CreateReservationDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_details do |t|
      t.belongs_to :reservation, null: false, foreign_key: true
      t.integer :price, null: false
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
