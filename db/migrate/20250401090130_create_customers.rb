class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      # devise 認証用
      t.string :email, default: ''
      t.string :encrypted_password, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.timestamps null: false
    end

    add_index :customers, :email,                unique: true
    add_index :customers, :reset_password_token, unique: true
    add_index :customers, :confirmation_token,   unique: true
  end
end
