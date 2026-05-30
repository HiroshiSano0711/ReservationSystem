class CreateReservationStatusLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_status_logs do |t|
      t.belongs_to :reservation, null: false, foreign_key: true
      t.integer :from_status, null: false, comment: '変更前ステータス'
      t.integer :to_status, null: false, comment: '変更後ステータス'
      t.integer :changed_by, null: false, comment: '変更者の種別'
      t.timestamps
    end
  end
end
