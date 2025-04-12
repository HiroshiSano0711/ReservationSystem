class CreateTeamBusinessSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :team_business_settings do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.jsonb :business_hours_for_day_of_week, null: false, comment: '営業時間／曜日'
      t.integer :max_reservation_month, null: false, comment: '最大受付月数'
      t.integer :reservation_start_delay_days, default: 0, null: false, comment: '予約受付猶予（日数）'
      t.integer :cancellation_deadline_hours_before, default: 24, null: false, comment: '予約キャンセル期限（時間）'

      t.timestamps
    end
  end
end
