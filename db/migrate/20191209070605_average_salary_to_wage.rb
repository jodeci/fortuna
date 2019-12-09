class AverageSalaryToWage < ActiveRecord::Migration[5.2]
  def change
    rename_column :yearend_bonuses, :average_salary, :average_wage
  end
end
