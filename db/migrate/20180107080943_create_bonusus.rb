class CreateBonusus < ActiveRecord::Migration[5.1]
  def change
    create_table :bonusus do |t|
      t.string :title
      t.integer :amount, default: 0

      t.integer :payroll_id
      t.timestamps
    end
  end
end
