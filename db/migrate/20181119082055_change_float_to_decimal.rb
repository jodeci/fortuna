class ChangeFloatToDecimal < ActiveRecord::Migration[5.2]
  def up
    change_column :payrolls, :parttime_hours, :decimal, default: 0
    change_column :payrolls, :leavetime_hours, :decimal, default: 0
    change_column :payrolls, :sicktime_hours, :decimal, default: 0
    change_column :payrolls, :vacation_refund_hours, :decimal, default: 0
    change_column :overtimes, :hours, :decimal, default: 0
    change_column :salaries, :monthly_wage_adjustment, :decimal, default: 1
  end

  def down
    change_column :payrolls, :parttime_hours, :float, default: 0
    change_column :payrolls, :leavetime_hours, :float, default: 0
    change_column :payrolls, :sicktime_hours, :float, default: 0
    change_column :payrolls, :vacation_refund_hours, :float, default: 0
    change_column :overtimes, :hours, :float, default: 0
    change_column :salaries, :monthly_wage_adjustment, :float, default: 1
  end
end
