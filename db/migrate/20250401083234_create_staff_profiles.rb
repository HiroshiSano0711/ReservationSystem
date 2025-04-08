class CreateStaffProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_profiles do |t|
      t.belongs_to :staff, null: false, foreign_key: true
      t.integer :working_status, null: false, default: 0, comment: '勤務状況'
      t.string :nick_name, null: false, default: '', comment: 'ニックネーム'
      t.string :profile_image, null: false, default: '', comment: 'プロフィール画像'
      t.boolean :accepts_direct_booking, null: false, default: false, comment: '指名受付'
      t.text :bio, null: false, default: '', comment: '自己紹介'
      t.timestamps
    end
  end
end
