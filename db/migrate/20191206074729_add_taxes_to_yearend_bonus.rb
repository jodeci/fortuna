class AddTaxesToYearendBonus < ActiveRecord::Migration[5.2]
  def change
    add_column :yearend_bonuses, :income_tax, :integer, default: 0
    add_column :yearend_bonuses, :health_insurance, :integer, default: 0
    add_column :yearend_bonuses, :total, :integer, default: 0
  end
end
