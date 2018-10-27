class ChangeIrregularToSubsidy < ActiveRecord::Migration[5.2]
  def change
    rename_column :statements, :irregular_income, :subsidy_income
  end
end
