class AddCorrectToStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :correction, :integer, default: 0
  end
end
