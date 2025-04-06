class CreateCustomerProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :customer_profiles do |t|
      t.string :name, null: false, default: ''
      t.string :phone_number, null: false, default: ''

      t.timestamps
    end
  end
end
