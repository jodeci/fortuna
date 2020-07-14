class AddTermToSalary < ActiveRecord::Migration[5.2]
  def change
    add_column :salaries, :term_id, :integer
  end
end
