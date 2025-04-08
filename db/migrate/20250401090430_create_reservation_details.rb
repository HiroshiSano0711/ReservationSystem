class CreateReservationDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_details do |t|
      t.belongs_to :reservation, null: false, foreign_key: true
      t.belongs_to :staff, foreign_key: true
      t.belongs_to :service_menu, null: false, foreign_key: true
      t.string :menu_name, null: false, default: ''
      t.integer :price, null: false
      t.integer :duration, null: false
      t.integer :required_staff_count
      t.string :customer_name, null: false, default: ''
      t.string :customer_phone_number, null: false, default: ''
      t.timestamps
    end
  end
end
