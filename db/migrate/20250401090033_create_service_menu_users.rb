class CreateServiceMenuUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :service_menu_users do |t|
      t.belongs_to :service_menu, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
  end
end
