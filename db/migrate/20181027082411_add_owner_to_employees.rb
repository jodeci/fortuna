class AddOwnerToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :owner, :boolean, default: false
  end
end
