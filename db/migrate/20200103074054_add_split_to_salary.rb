class AddSplitToSalary < ActiveRecord::Migration[5.2]
  def change
    add_column :salaries, :split, :boolean, default: false
  end
end
