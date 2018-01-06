class CreatePayrolls < ActiveRecord::Migration[5.1]
  def change
    create_table :payrolls do |t|
      t.integer :year
      t.integer :month
      t.float :leavetime_hours, default: 0
      t.float :vacation_refund_hours, default: 0
      t.integer :overtime_meals, default: 0
      t.integer :business_trip_days, default: 0

      t.integer :employee_id
      t.timestamps
    end
  end
end
