class CreateReservatoinDetailUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :reservatoin_detail_users do |t|
      t.belongs_to :reservation_detail, null: false, foreign_key: true
      t.belongs_to :service_menu_user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
