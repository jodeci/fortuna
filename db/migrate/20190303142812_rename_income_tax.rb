class RenameIncomeTax < ActiveRecord::Migration[5.2]
  def change
    rename_column :salaries, :income_tax, :fixed_income_tax
  end
end
