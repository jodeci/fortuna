# frozen_string_literal: true
namespace :dev do
  desc "reset db"
  task reset_database: :environment do
    raise "You cannot run this in production" if Rails.env.production?
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
  end

  desc "force update salary/payroll/statement data"
  task fix_data: :environment do
    Payroll.ordered.map do |payroll|
      payroll.update(salary: payroll.find_salary)
      StatementService::Builder.call(payroll)
    end
  end
end
