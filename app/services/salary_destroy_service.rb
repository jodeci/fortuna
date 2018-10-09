# frozen_string_literal: true
class SalaryDestroyService < SalarySyncService
  def call
    salary.destroy
    sync_payroll_relations
    sync_statements
  end

  private

  def effective_date
    nil
  end
end
