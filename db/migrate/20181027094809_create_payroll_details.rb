class CreatePayrollDetails < ActiveRecord::Migration[5.2]
  def change
    create_view :payroll_details
  end
end
