class AddExcessIncomeToStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :excess_income, :integer, default: 0
  end
end
