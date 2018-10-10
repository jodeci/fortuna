# frozen_string_literal: true
namespace :fix do
  desc "add salary relation to payroll"
  task salary: :environment do
    Payroll.ordered.map do |payroll|
      payroll.update(salary: payroll.find_salary)
      StatementSyncService.call(payroll)
    end
  end
end
