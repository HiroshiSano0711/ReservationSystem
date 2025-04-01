class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :customer
      t.string :public_id
      t.string :customer_name
      t.string :customer_phone_number
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status
      t.timestamps
    end
  end
end
