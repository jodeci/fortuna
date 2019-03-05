class AddTaxIncomeToSalary < ActiveRecord::Migration[5.2]
  def change
    add_column :salaries, :income_tax, :integer, :default => 0
  end
end
