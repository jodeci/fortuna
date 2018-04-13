class AddCycleToSalaries < ActiveRecord::Migration[5.1]
  def change
    add_column :salaries, :cycle, :string, default: "normal"
  end
end
