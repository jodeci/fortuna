class CreateStatements < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.integer :amount, default: 0
      t.integer :year
      t.integer :month
      t.integer :splits, default: nil, array: true

      t.integer :payroll_id
      t.timestamps
    end
  end
end
