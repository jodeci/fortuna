class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :company_email
      t.string :personal_email
      t.string :id_number
      t.string :residence_address
      t.date :birthday
      t.string :bank_account
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
