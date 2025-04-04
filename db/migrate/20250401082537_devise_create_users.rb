# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.belongs_to :team, null: false, foreign_key: true

      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.integer :role, null: false, default: 1
      t.string :nick_name, null: false
      t.string :profile_image
      t.integer :status, null: false
      t.boolean :accepts_direct_booking, null: false, default: false
      t.text :bio

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end
end
