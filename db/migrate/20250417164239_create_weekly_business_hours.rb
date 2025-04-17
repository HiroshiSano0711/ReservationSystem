class CreateWeeklyBusinessHours < ActiveRecord::Migration[8.0]
  def change
    create_table :weekly_business_hours do |t|
      t.belongs_to :team_business_setting, null: false, foreign_key: true
      t.integer :wday, null: false, comment: '曜日'
      t.boolean :working_day, default: true, null: false, comment: '営業日か休日か'
      t.time :open, null: false, comment: 'オープン'
      t.time :close, null: false, comment: 'クローズ'
      t.timestamps
    end

    add_index :weekly_business_hours, [:team_business_setting_id, :wday], unique: true
  end
end
