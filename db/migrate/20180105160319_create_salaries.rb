class CreateSalaries < ActiveRecord::Migration[5.1]
  def change
    create_table :salaries do |t|
      t.string :role
      t.string :tax_code, default: 50
      t.integer :monthly_wage, default: 0
      t.integer :hourly_wage, default: 0
      t.date :effective_date
      t.integer :equipment_subsidy, default: 0
      t.integer :commuting_subsidy, default: 0
      t.integer :supervisor_allowance, default: 0
      t.integer :labor_insurance, default: 0
      t.integer :health_insurance, default: 0

      t.integer :employee_id
      t.timestamps
    end
  end
end
