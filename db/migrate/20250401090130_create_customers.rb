class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      # devise 認証用
      t.string :email, default: ''
      t.string :encrypted_password, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

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

    add_index :customers, :email,                unique: true
    add_index :customers, :reset_password_token, unique: true
    add_index :customers, :invitation_token,     unique: true
    add_index :customers, :invited_by_id
  end
end
