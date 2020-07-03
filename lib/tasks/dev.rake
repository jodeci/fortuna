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
      salary = SalaryService::Finder.call(
        payroll.employee,
        Date.new(payroll.year, payroll.month, 1),
        Date.new(payroll.year, payroll.month, -1)
      )
      payroll.update(salary: salary)
      StatementService::Builder.call(payroll)
    end
  end

  # 做第一次資料移轉
  desc "move employee start/end date to terms"
  task init_term: :environment do
    Employee.all.map do |employee|
      Term.create(start_date: employee.start_date, end_date: employee.end_date, employee_id: employee.id)
    end
  end

  desc "statement force update"
  task update_statements: :environment do
    Payroll.ordered.map do |payroll|
      StatementService::Builder.call(payroll)
    end
  end
end
