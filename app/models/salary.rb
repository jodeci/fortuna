# frozen_string_literal: true
class Salary < ApplicationRecord
  belongs_to :employee

  def self.by_payroll(employee, period_start, period_end)
    return if employee.end_date and employee.end_date < period_start
    where("employee_id = ? AND start_date < ?", employee.id, period_end)
      .order(start_date: :asc)
      .last
  end

  # 一般薪資所得
  def regular?
    tax_code == "50" and labor_insurance.positive?
  end

  # 兼職薪資所得（適用二代健保）
  def parttime?
    tax_code == "50" and labor_insurance.zero?
  end

  # 執行業務所得（適用二代健保、需預扣 10% 所得稅）
  def professional_service?
    tax_code.casecmp("9a").zero?
  end
end
