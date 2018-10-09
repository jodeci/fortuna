# frozen_string_literal: true
class SalaryUpdateService < SalarySyncService
  def call
    salary.update_attributes(params)
    sync_payroll_relations if effective_date_change?
    sync_statements
  end

  private

  def effective_date_change?
    salary.effective_date_before_last_save != effective_date
  end
end
