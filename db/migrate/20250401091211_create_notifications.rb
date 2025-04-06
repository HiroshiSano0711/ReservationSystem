class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.bigint :sender_id, null: false
      t.bigint :receiver_id, null: false
      t.integer :status, null: false
      t.integer :notification_type, null: false
      t.text :message, null: false
      t.string :action_url, null: false
      t.timestamps

      t.index :sender_id
      t.index :receiver_id
    end
  end
end
