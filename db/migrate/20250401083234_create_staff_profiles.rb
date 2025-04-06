class CreateStaffProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_profiles do |t|
      t.belongs_to :staff, null: false, foreign_key: true
      t.integer :working_status, null: false
      t.string :nick_name, null: false, default: ''
      t.string :profile_image, null: false, default: ''
      t.boolean :accepts_direct_booking, null: false, default: false
      t.text :bio, null: false, default: ''
      t.timestamps
    end
  end
end
