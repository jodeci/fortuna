class AddFestivalToPayrolls < ActiveRecord::Migration[5.1]
  def change
    add_column :payrolls, :festival_bonus, :integer, default: 0
    add_column :payrolls, :festival_type, :string, default: nil
  end
end
