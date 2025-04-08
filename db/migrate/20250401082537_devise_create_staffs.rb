# frozen_string_literal: true

class DeviseCreateStaffs < ActiveRecord::Migration[8.0]
  def change
    create_table :staffs do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.integer :role, null: false, default: 1, comment: 'ロール'

      ### devise 認証用 ###
      # data authenticate
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      # confirmation
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      
      # invitable
      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      t.integer    :invitations_count, default: 0

      t.timestamps null: false
    end

    add_index :staffs, :email,                unique: true
    add_index :staffs, :reset_password_token, unique: true
    add_index :staffs, :confirmation_token,   unique: true
    add_index :staffs, :invitation_token,     unique: true
    add_index :staffs, :invited_by_id
  end
end
