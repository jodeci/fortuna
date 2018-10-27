class RemoveBonusIncomeFromStatements < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :bonus_income, :integer
  end
end
