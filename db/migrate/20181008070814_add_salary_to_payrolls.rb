class AddSalaryToPayrolls < ActiveRecord::Migration[5.1]
  def change
    add_column :payrolls, :salary_id, :integer
  end
end
