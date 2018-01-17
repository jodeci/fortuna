# frozen_string_literal: true
class Salary < ApplicationRecord
  default_scope { order(start_date: :desc) }
  belongs_to :employee

  def self.by_payroll(employee, period_start, period_end)
    return if employee.end_date and employee.end_date < period_start
    find_by("employee_id = ? AND start_date < ?", employee.id, period_end)
  end

  # 一般薪資所得
  def regular_income?
    tax_code == "50" and insuranced?
  end

  # 兼職薪資所得
  def parttime_income?
    tax_code == "50" and !insuranced?
  end

  # 執行業務所得
  def professional_service?
    tax_code == "9a"
  end

  def insuranced?
    labor_insurance.positive?
  end

  def contractor?
    role == "contractor"
  end
end
