class AddMonthlyWageAdjustmentToSalary < ActiveRecord::Migration[5.1]
  def change
    add_column :salaries, :monthly_wage_adjustment, :float, default: 1.0
  end
end
