class CreateReservationDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_details do |t|
      t.belongs_to :reservation, null: false, foreign_key: true
      t.belongs_to :staff, foreign_key: true
      t.belongs_to :service_menu, null: false, foreign_key: true
      t.string :menu_name, null: false, default: '', comment: 'メニュー名'
      t.integer :price, null: false, comment: '価格'
      t.integer :duration, null: false, comment: '所要時間'
      t.integer :required_staff_count, null: false, comment: '所要人数'
      t.timestamps
    end
  end
end
