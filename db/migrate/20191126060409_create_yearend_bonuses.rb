class CreateYearendBonuses < ActiveRecord::Migration[5.2]
  def change
    create_table :yearend_bonuses do |t|
      t.integer :average_salary, default: 0
      t.decimal :multiplier, default: 0
      t.integer :salary_based_bonus, default: 0
      t.integer :fixed_amount, default: 0
      t.integer :cash_benefit, default: 0
      t.integer :employee_id
      t.integer :lunar_year_id

      t.timestamps
    end
  end
end
