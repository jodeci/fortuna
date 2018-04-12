class AddBankTransferTypeToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :bank_transfer_type, :string, default: "salary"
  end
end
