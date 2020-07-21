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
      salary_id = SalaryTracker.salary_by_payroll(payroll: payroll)
      payroll.update(salary_id: salary_id)
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

  # 修補 salary/term 的關連資料
  desc "fix salary/term relationship"
  task salary_term: :environment do
    Salary.all.map do |salary|
      term = SalaryService::TermFinder.call(salary)
      salary.term_id = term.id
      salary.save
    end
  end

  # 計算 correction
  desc "update correction"
  task correction: :environment do
    Statement.all.map do |statement|
      if statement.corrections.any?
        statement.correction = statement.corrections.inject(0) { |sum, row| sum + row.amount }
        statement.save
      end
    end
  end
end
