class AddBonusIncomeToStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :bonus_income, :integer, default: 0
  end
end
