class AddIrregularIncomeToStatements < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :irregular_income, :integer, default: 0
  end
end
