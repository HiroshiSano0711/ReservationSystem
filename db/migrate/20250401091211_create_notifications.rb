class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.bigint :sender, null: false
      t.bigint :receiver, null: false
      t.integer :status, null: false
      t.integer :notification_type, null: false
      t.text :message, null: false
      t.string :action_url, null: false
      t.timestamps
    end
  end
end
