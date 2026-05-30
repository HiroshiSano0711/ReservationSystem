class CreateReservationStaffAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_staff_assignments do |t|
      t.belongs_to :reservation_detail, null: false, foreign_key: true
      t.belongs_to :staff, null: false, foreign_key: true
      t.timestamps
    end
  end
end
