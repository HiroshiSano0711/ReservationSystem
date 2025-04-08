class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false, comment: 'チーム名'
      t.string :permalink, null: false, comment: '予約URL'
      t.text :description, comment: '概要'
      t.string :phone_number, comment: '連絡先電話番号'
      t.timestamps

      t.index :name, unique: true
      t.index :permalink, unique: true
    end
  end
end
