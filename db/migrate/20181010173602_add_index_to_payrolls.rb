class AddIndexToPayrolls < ActiveRecord::Migration[5.1]
  def change
    add_index :payrolls, :year
    add_index :payrolls, :month
  end
end
