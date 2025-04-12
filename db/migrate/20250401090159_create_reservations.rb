class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :customer, foreign_key: true

      t.string :public_id, null: false, comment: '予約ID（公開用）'
      t.date :date, null: false, comment: '予約日'
      t.time :start_time, null: false, comment: '開始時間'
      t.time :end_time, null: false, comment: '終了時間'
      t.string :customer_name, null: false, default: '', comment: '顧客名'
      t.string :customer_phone_number, null: false, default: '', comment: '顧客連絡先'
      t.integer :total_price, null: false, comment: '合計価格'
      t.integer :total_duration, null: false, comment: '合計所要時間'
      t.integer :required_staff_count, null: false, comment: '合計所要人数'
      t.text :menu_summary, null: false, default: '', comment: 'メニュー'
      t.string :assigned_staff_name, null: false, default: '', comment: '担当者名'
      t.text :memo, null: false, default: '', comment: '希望・要望など'
      t.integer :status, null: false, default: 0, comment: 'ステータス'
      t.timestamps

      t.index :public_id, unique: true
    end
  end
end
