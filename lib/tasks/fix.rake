# frozen_string_literal: true
namespace :fix do
  desc "add salary to payroll"
  task salary: :environment do
    Payroll.ordered.map do |payroll|
      salary = Salary.by_payroll(
        payroll.employee, Date.new(payroll.year, payroll.month, 1), Date.new(payroll.year, payroll.month, -1)
      )
      payroll.update(salary: salary)
    end
  end
end
