class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.bigint :sender_id
      t.bigint :receiver_id, null: false
      t.integer :status, null: false, comment: 'ステータス'
      t.integer :notification_type, null: false, comment: 'タイプ'
      t.text :message, null: false, comment: '通知内容'
      t.string :action_url, null: false, comment: 'アクションURL'
      t.timestamps

      t.index :sender_id
      t.index :receiver_id
    end
  end
end
