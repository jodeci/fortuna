class AddIncomeTypeToExtraEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :extra_entries, :income_type, :string, default: "salary"
  end
end
