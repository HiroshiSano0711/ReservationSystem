class CreateCustomerProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :customer_profiles do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :name, null: false, default: '', comment: '名前'
      t.string :phone_number, null: false, default: '', comment: '電話番号'

      t.timestamps
    end
  end
end
