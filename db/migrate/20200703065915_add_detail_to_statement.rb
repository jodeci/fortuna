class AddDetailToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :gain, :jsonb
    add_column :statements, :loss, :jsonb
  end
end
