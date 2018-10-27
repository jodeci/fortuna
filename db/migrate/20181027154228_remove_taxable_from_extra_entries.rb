class RemoveTaxableFromExtraEntries < ActiveRecord::Migration[5.2]
  def change
    remove_column :extra_entries, :taxable, :boolean
  end
end
