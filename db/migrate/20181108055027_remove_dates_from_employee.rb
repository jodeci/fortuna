class RemoveDatesFromEmployee < ActiveRecord::Migration[5.2]
  def change
    remove_column :employees, :start_date, :date
    remove_column :employees, :end_date, :date
  end
end
