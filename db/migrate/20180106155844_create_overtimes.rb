class CreateOvertimes < ActiveRecord::Migration[5.1]
  def change
    create_table :overtimes do |t|
      t.date :date
      t.string :rate
      t.float :hours, default: 0

      t.integer :payroll_id
      t.timestamps
    end
  end
end
