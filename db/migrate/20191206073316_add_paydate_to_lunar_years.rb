class AddPaydateToLunarYears < ActiveRecord::Migration[5.2]
  def change
    add_column :lunar_years, :paydate, :date, default: nil
  end
end
