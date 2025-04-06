class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :customer

      t.string :public_id, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :customer_name, null: false, default: ''
      t.string :customer_phone_number, null: false, default: ''
      t.integer :total_price, null: false
      t.integer :total_duration, null: false
      t.text :menu_summary, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.integer :status, null: false, default: 0
      t.timestamps

      t.index :public_id, unique: true
    end
  end
end
