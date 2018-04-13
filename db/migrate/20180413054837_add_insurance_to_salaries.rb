class AddInsuranceToSalaries < ActiveRecord::Migration[5.1]
  def change
    add_column :salaries, :insured_for_health, :integer, default: 0
    add_column :salaries, :insured_for_labor, :integer, default: 0
  end
end
