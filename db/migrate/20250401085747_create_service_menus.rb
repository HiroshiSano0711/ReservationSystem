class CreateServiceMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :service_menus do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.string :menu_name, null: false, default: '', comment: 'メニュー名'
      t.integer :duration, null: false, default: 0, comment: '所要時間'
      t.integer :price, null: false, default: 0, comment: '価格（税込）'
      t.integer :required_staff_count, null: false, default: 1, comment: '所要人数'
      t.date :available_from, null: false, comment: '提供開始日'
      t.date :available_until, comment: '提供終了日'

      t.timestamps
      t.index [ :team_id, :menu_name ], unique: true
    end
  end
end
