# frozen_string_literal: true
module SalaryService
  class Create < Base
    def call
      salary.save
      sync_payroll_relations if effective_date_backtrack?
      sync_statements
    end

    private

    def effective_date_backtrack?
      recent_salary.effective_date > effective_date
    end

    def recent_salary
      Salary.recent_for(salary.employee)
    end
  end
end
