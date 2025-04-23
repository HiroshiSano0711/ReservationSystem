class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :receiver, null: false, foreign_key: { to_table: :staffs }, comment: '受信者（Staff）'
      t.boolean :is_read, null: false, default: false, comment: '既読か未読か'
      t.integer :notification_type, null: false, comment: 'タイプ'
      t.string :action_url, null: false, comment: 'アクションURL'
      t.timestamps
    end
  end
end
