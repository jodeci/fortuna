class AddB2bToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :b2b, :boolean, default: false
  end
end
