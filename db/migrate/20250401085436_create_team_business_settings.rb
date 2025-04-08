class CreateTeamBusinessSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :team_business_settings do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.jsonb :business_hours_for_day_of_week, null: false, comment: '営業時間／曜日'
      t.integer :max_reservation_month, null: false, comment: '最大受付月数'

      t.timestamps
    end
  end
end
