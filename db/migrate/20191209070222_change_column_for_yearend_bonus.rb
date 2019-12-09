class ChangeColumnForYearendBonus < ActiveRecord::Migration[5.2]
  def change
    add_column :yearend_bonuses, :seniority_factor, :decimal, default: 1
  end
end
