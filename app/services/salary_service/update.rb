# frozen_string_literal: true
module SalaryService
  class Update < Base
    def call
      salary.update(params)
      sync_payroll_relations if effective_date_change?
      sync_statements
    end

    private

    def effective_date_change?
      salary.effective_date_before_last_save != effective_date
    end
  end
end
