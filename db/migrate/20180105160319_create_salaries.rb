class CreateSalaries < ActiveRecord::Migration[5.1]
  def change
    create_table :salaries do |t|
      t.boolean :monthly, default: true
      t.integer :base, default: 0
      t.date :start_date
      t.integer :equipment_subsidy, default: 0
      t.integer :commuting_subsidy, default: 0
      t.integer :supervisor_allowance, default: 0

      t.integer :employee_id
      t.timestamps
    end
  end
end
