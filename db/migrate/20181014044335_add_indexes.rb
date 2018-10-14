class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :employees, :start_date
    add_index :employees, :end_date
    add_index :payrolls, :salary_id
    add_index :payrolls, :employee_id
    add_index :salaries, :employee_id
    add_index :salaries, :effective_date
    add_index :statements, :payroll_id
    add_index :overtimes, :payroll_id
    add_index :extra_entries, :payroll_id
    add_index :corrections, :statement_id
  end
end
