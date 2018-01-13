class CreateExtraEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :extra_entries do |t|
      t.string :title
      t.integer :amount, default: 0
      t.boolean :taxable, default: false
      t.string :note, null: true

      t.integer :payroll_id
      t.timestamps
    end
  end
end
