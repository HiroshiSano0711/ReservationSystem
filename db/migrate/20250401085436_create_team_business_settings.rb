class CreateTeamBusinessSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :team_business_settings do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.jsonb :working_wday, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :max_reservation_month, null: false

      t.timestamps
    end
  end
end
