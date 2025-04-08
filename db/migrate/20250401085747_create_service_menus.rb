class CreateServiceMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :service_menus do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.string :menu_name, null: false, default: ''
      t.integer :duration, null: false, default: 0
      t.integer :price, null: false, default: 0
      t.integer :required_staff_count, null: false, default: 1
      t.date :available_from, null: false
      t.date :available_until

      t.timestamps
      t.index [:team_id, :menu_name], unique: true
    end
  end
end
