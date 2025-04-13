class CreateServiceMenuUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :service_menu_staffs do |t|
      t.belongs_to :service_menu, null: false, foreign_key: true
      t.belongs_to :staff, null: false, foreign_key: true
      t.integer :priority, null: false, default: 0, comment: '優先度'
      t.timestamps

      t.index [ :staff_id, :service_menu_id ], unique: true
    end
  end
end
