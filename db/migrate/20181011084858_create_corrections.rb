class CreateCorrections < ActiveRecord::Migration[5.1]
  def change
    create_table :corrections do |t|
      t.integer :statement_id
      t.integer :amount, default: 0
      t.string :description
      t.timestamps
    end
  end
end
