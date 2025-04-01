class CreateServiceMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :service_menus do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.string :menu_name, null: false
      t.integer :duration, null: false
      t.integer :price, null: false
      t.integer :required_staff_count, null: false, default: 1

      t.timestamps
    end
  end
end
